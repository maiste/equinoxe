open! Dune_engine
open! Dune_engine.Import
open! Stdune

module Jbuild_plugin : sig
  val create_plugin_wrapper :
       Context.t
    -> exec_dir:Path.t
    -> plugin:Path.t
    -> wrapper:Path.Build.t
    -> target:Path.Build.t
    -> unit
end = struct
  let replace_in_template =
    let template =
      lazy
        (let marker name =
           let open Re in
           [ str "(*$"; rep space; str name; rep space; str "$*)" ]
           |> seq |> Re.mark
         in
         let mark_start, marker_start = marker "begin_vars" in
         let mark_end, marker_end = marker "end_vars" in
         let markers = Re.alt [ marker_start; marker_end ] in
         let invalid_template stage =
           Code_error.raise
             "Jbuild_plugin.replace_in_template: invalid template"
             [ ("stage", Dyn.Encoder.string stage) ]
         in
         let rec parse1 = function
           | `Text s :: xs -> parse2 s xs
           | xs -> parse2 "" xs
         and parse2 prefix = function
           | `Delim ds :: `Text _ :: `Delim de :: xs
             when Re.Mark.test ds mark_start && Re.Mark.test de mark_end ->
             parse3 prefix xs
           | _ -> invalid_template "parse2"
         and parse3 prefix = function
           | [] -> (prefix, "")
           | [ `Text suffix ] -> (prefix, suffix)
           | _ -> invalid_template "parse3"
         in
         let tokens =
           Re.split_full (Re.compile markers) Assets.jbuild_plugin_ml
         in
         parse1 tokens)
    in
    fun t ->
      let prefix, suffix = Lazy.force template in
      sprintf "%s%s%s" prefix t suffix

  let write oc ~(context : Context.t) ~target ~exec_dir ~plugin ~plugin_contents
      =
    let ocamlc_config =
      let vars =
        Ocaml_config.to_list context.ocaml_config
        |> List.map ~f:(fun (k, v) -> (k, Ocaml_config.Value.to_string v))
      in
      let longest = String.longest_map vars ~f:fst in
      List.map vars ~f:(fun (k, v) -> sprintf "%-*S , %S" (longest + 2) k v)
      |> String.concat ~sep:"\n      ; "
    in
    let vars =
      Printf.sprintf
        {|let context = %S
        let ocaml_version = %S
        let send_target = %S
        let ocamlc_config = [ %s ]
        |}
        (Context_name.to_string context.name)
        (Ocaml_config.version_string context.ocaml_config)
        (Path.reach ~from:exec_dir (Path.build target))
        ocamlc_config
    in
    Printf.fprintf oc
      "module Jbuild_plugin : sig\n%s\nend = struct\n%s\nend\n# 1 %S\n%s"
      Assets.jbuild_plugin_mli (replace_in_template vars)
      (Path.to_string plugin) plugin_contents

  let check_no_requires path str =
    List.iteri (String.split str ~on:'\n') ~f:(fun n line ->
        match Scanf.sscanf line "#require %S" (fun x -> x) with
        | Error () -> ()
        | Ok (_ : string) ->
          let loc : Loc.t =
            let start : Lexing.position =
              { pos_fname = Path.to_string path
              ; pos_lnum = n
              ; pos_cnum = 0
              ; pos_bol = 0
              }
            in
            { start; stop = { start with pos_cnum = String.length line } }
          in
          User_error.raise ~loc
            [ Pp.text "#require is no longer supported in dune files."
            ; Pp.text
                "You can use the following function instead of \
                 Unix.open_process_in:\n\n\
                \  (** Execute a command and read it's output *)\n\
                \  val run_and_read_lines : string -> string list"
            ])

  let create_plugin_wrapper (context : Context.t) ~exec_dir ~plugin ~wrapper
      ~target =
    let plugin_contents = Io.read_file plugin in
    Io.with_file_out (Path.build wrapper) ~f:(fun oc ->
        write oc ~context ~target ~exec_dir ~plugin ~plugin_contents);
    check_no_requires plugin plugin_contents
end

module Dune_files = struct
  type script =
    { dir : Path.Source.t
    ; file : Path.Source.t
    ; project : Dune_project.t
    }

  type one =
    | Literal of Dune_file.t
    | Script of
        { script : script
        ; from_parent : Dune_lang.Ast.t list
        }

  type t = one list

  let generated_dune_files_dir = Path.Build.relative Path.Build.root ".dune"

  let ensure_parent_dir_exists path =
    Path.build path |> Path.parent |> Option.iter ~f:Path.mkdir_p

  let eval dune_files ~(context : Context.t) =
    let open Memo.Build.O in
    let static, dynamic =
      List.partition_map dune_files ~f:(function
        | Literal x -> Left x
        | Script { script; from_parent } -> Right (script, from_parent))
    in
    Memo.Build.parallel_map dynamic
      ~f:(fun ({ dir; file; project }, from_parent) ->
        let generated_dune_file =
          Path.Build.append_source
            (Path.Build.relative generated_dune_files_dir
               (Context_name.to_string context.name))
            file
        in
        let wrapper =
          Path.Build.extend_basename generated_dune_file ~suffix:".ml"
        in
        ensure_parent_dir_exists generated_dune_file;
        Jbuild_plugin.create_plugin_wrapper context ~exec_dir:(Path.source dir)
          ~plugin:(Path.source file) ~wrapper ~target:generated_dune_file;
        let context = Option.value context.for_host ~default:context in
        let args =
          List.concat
            [ [ "-I"; "+compiler-libs" ]
            ; [ Path.to_absolute_filename (Path.build wrapper) ]
            ]
        in
        let ocaml = Action.Prog.ok_exn context.ocaml in
        let* () =
          Memo.Build.of_reproducible_fiber
            (Process.run Strict ~dir:(Path.source dir) ~env:context.env ocaml
               args)
        in
        if not (Path.exists (Path.build generated_dune_file)) then
          User_error.raise
            [ Pp.textf "%s failed to produce a valid dune_file file."
                (Path.Source.to_string_maybe_quoted file)
            ; Pp.textf "Did you forgot to call [Jbuild_plugin.V*.send]?"
            ];
        Memo.Build.return
          (Dune_lang.Parser.load (Path.build generated_dune_file) ~mode:Many
          |> List.rev_append from_parent
          |> Dune_file.parse ~dir ~file ~project))
    >>| fun dynamic -> static @ dynamic
end

type conf =
  { dune_files : Dune_files.t
  ; packages : Package.t Package.Name.Map.t
  ; projects : Dune_project.t list
  }

let interpret ~dir ~project ~(dune_file : Source_tree.Dune_file.t) =
  let file = Source_tree.Dune_file.path dune_file in
  let static = Source_tree.Dune_file.get_static_sexp dune_file in
  match Source_tree.Dune_file.kind dune_file with
  | Ocaml_script ->
    Dune_files.Script { script = { dir; project; file }; from_parent = static }
  | Plain -> Literal (Dune_file.parse static ~dir ~file ~project)

module Projects_and_dune_files =
  Monoid.Product
    (Monoid.Appendable_list (struct
      type t = Dune_project.t
    end))
    (Monoid.Appendable_list (struct
      type t = Path.Source.t * Dune_project.t * Source_tree.Dune_file.t
    end))

module Source_tree_map_reduce =
  Source_tree.Make_map_reduce_with_progress
    (Memo.Build)
    (Projects_and_dune_files)

let load () =
  let open Memo.Build.O in
  let+ projects, dune_files =
    let f dir : Projects_and_dune_files.t Memo.Build.t =
      let path = Source_tree.Dir.path dir in
      let project = Source_tree.Dir.project dir in
      let projects =
        if Path.Source.equal path (Dune_project.root project) then
          Appendable_list.singleton project
        else
          Appendable_list.empty
      in
      let dune_files =
        match Source_tree.Dir.dune_file dir with
        | None -> Appendable_list.empty
        | Some d -> Appendable_list.singleton (path, project, d)
      in
      Memo.Build.return (projects, dune_files)
    in
    Source_tree_map_reduce.map_reduce ~traverse:Sub_dirs.Status.Set.all ~f
  in
  let projects = Appendable_list.to_list projects in
  let packages =
    List.fold_left projects ~init:Package.Name.Map.empty
      ~f:(fun acc (p : Dune_project.t) ->
        Package.Name.Map.merge acc (Dune_project.packages p) ~f:(fun name a b ->
            Option.merge a b ~f:(fun a b ->
                User_error.raise
                  [ Pp.textf "Too many opam files for package %S:"
                      (Package.Name.to_string name)
                  ; Pp.textf "- %s"
                      (Path.Source.to_string_maybe_quoted (Package.opam_file a))
                  ; Pp.textf "- %s"
                      (Path.Source.to_string_maybe_quoted (Package.opam_file b))
                  ])))
  in
  let dune_files =
    List.map (Appendable_list.to_list dune_files)
      ~f:(fun (dir, project, dune_file) -> interpret ~dir ~project ~dune_file)
  in
  { dune_files; packages; projects }

let load =
  let memo = Memo.lazy_ load in
  fun () -> Memo.Lazy.force memo
