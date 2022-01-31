open! Dune_engine
open! Stdune
open Import

let () = Inline_tests.linkme

type build_system =
  { conf : Dune_load.conf
  ; contexts : Context.t list
  ; scontexts : Super_context.t Context_name.Map.t
  }

let implicit_default_alias dir =
  let open Memo.Build.O in
  match Path.Build.extract_build_context dir with
  | None -> Memo.Build.return None
  | Some (ctx_name, src_dir) -> (
    Source_tree.find_dir src_dir >>| function
    | None -> None
    | Some dir ->
      let default_alias =
        let dune_version =
          Source_tree.Dir.project dir |> Dune_project.dune_version
        in
        if dune_version >= (2, 0) then
          Alias.Name.all
        else
          Alias.Name.install
      in
      Some
        (Action_builder.ignore
           (Action_builder.dep_on_alias_rec default_alias
              (Context_name.of_string ctx_name)
              dir)))

let init ~stats ~sandboxing_preference ~cache_config ~cache_debug_flags ~handler
    =
  let promote_source ?chmod ~src ~dst ctx =
    let open Fiber.O in
    let* ctx =
      Memo.Build.run
        (Memo.Build.Option.map ctx ~f:(fun (ctx : Build_context.t) ->
             Context.DB.get ctx.name))
    in
    let conf = Artifact_substitution.conf_of_context ctx in
    let src = Path.build src in
    let dst = Path.source dst in
    Artifact_substitution.copy_file ?chmod ~src ~dst ~conf ()
  in
  Build_system.init ~stats ~sandboxing_preference ~promote_source
    ~contexts:
      (Memo.lazy_ (fun () ->
           let open Memo.Build.O in
           Workspace.workspace () >>| Workspace.build_contexts))
    ~cache_config ~cache_debug_flags
    ~rule_generator:(module Gen_rules)
    ~handler ~implicit_default_alias

let get () =
  let open Memo.Build.O in
  let* conf = Dune_load.load () in
  let* contexts = Context.DB.all () in
  let* scontexts = Memo.Lazy.force Super_context.all in
  Memo.Build.return { conf; contexts; scontexts }

let find_context_exn t ~name =
  match List.find t.contexts ~f:(fun c -> Context_name.equal c.name name) with
  | Some ctx -> ctx
  | None ->
    User_error.raise
      [ Pp.textf "Context %S not found!" (Context_name.to_string name) ]

let find_scontext_exn t ~name =
  match Context_name.Map.find t.scontexts name with
  | Some ctx -> ctx
  | None ->
    User_error.raise
      [ Pp.textf "Context %S not found!" (Context_name.to_string name) ]
