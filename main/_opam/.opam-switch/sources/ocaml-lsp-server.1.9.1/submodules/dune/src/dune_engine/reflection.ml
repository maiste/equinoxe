open Import
module Non_evaluated_rule = Rule
open Memo.Build.O

module Rule = struct
  type t =
    { id : Rule.Id.t
    ; dir : Path.Build.t
    ; deps : Dep.Set.t
    ; expanded_deps : Path.Set.t
    ; targets : Path.Build.Set.t
    ; context : Build_context.t option
    ; action : Action.t
    }
end

module Rule_top_closure =
  Top_closure.Make (Non_evaluated_rule.Id.Set) (Memo.Build)

module rec Expand : sig
  val alias : Alias.t -> Path.Set.t Memo.Build.t

  val deps : Dep.Set.t -> Path.Set.t Memo.Build.t
end = struct
  let alias =
    let memo =
      Memo.create "expand-alias"
        ~input:(module Alias)
        (fun alias ->
          let* l =
            Build_system.get_alias_definition alias
            >>= Memo.Build.parallel_map ~f:(fun (loc, definition) ->
                    Memo.push_stack_frame
                      (fun () ->
                        Action_builder.run
                          (Build_system.dep_on_alias_definition definition)
                          Lazy
                        >>| snd)
                      ~human_readable_description:(fun () ->
                        Alias.describe alias ~loc))
          in
          let deps = List.fold_left l ~init:Dep.Set.empty ~f:Dep.Set.union in
          Expand.deps deps)
    in
    Memo.exec memo

  let deps deps =
    Memo.Build.parallel_map (Dep.Set.to_list deps) ~f:(fun (dep : Dep.t) ->
        match dep with
        | File p -> Memo.Build.return (Path.Set.singleton p)
        | File_selector g -> Build_system.eval_pred g
        | Alias a -> Expand.alias a
        | Env _
        | Universe
        | Sandbox_config _ ->
          Memo.Build.return Path.Set.empty)
    >>| Path.Set.union_all
end

let evaluate_rule =
  let memo =
    Memo.create "evaluate-rule"
      ~input:(module Non_evaluated_rule)
      (fun rule ->
        let* action, deps = Action_builder.run rule.action Lazy in
        let* expanded_deps = Expand.deps deps in
        Memo.Build.return
          { Rule.id = rule.id
          ; dir = rule.dir
          ; deps
          ; expanded_deps
          ; targets = rule.targets
          ; context = rule.context
          ; action = action.action
          })
  in
  Memo.exec memo

let eval ~recursive ~request =
  let rules_of_deps deps =
    Expand.deps deps >>| Path.Set.to_list
    >>= Memo.Build.parallel_map ~f:(fun p ->
            Build_system.get_rule p >>= function
            | None -> Memo.Build.return None
            | Some rule -> evaluate_rule rule >>| Option.some)
    >>| List.filter_map ~f:Fun.id
  in
  let* (), deps = Action_builder.run request Lazy in
  let* root_rules = rules_of_deps deps in
  Rule_top_closure.top_closure root_rules
    ~key:(fun rule -> rule.Rule.id)
    ~deps:(fun rule ->
      if recursive then
        rules_of_deps rule.deps
      else
        Memo.Build.return [])
  >>| function
  | Ok l -> l
  | Error cycle ->
    User_error.raise
      [ Pp.text "Dependency cycle detected:"
      ; Pp.chain cycle ~f:(fun rule ->
            Pp.verbatim
              (Path.to_string_maybe_quoted
                 (Path.build (Path.Build.Set.choose_exn rule.targets))))
      ]
