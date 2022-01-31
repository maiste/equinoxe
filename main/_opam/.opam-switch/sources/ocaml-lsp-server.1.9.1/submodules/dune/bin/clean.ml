open Stdune
open Import

let command =
  let doc = "Clean the project." in
  let man =
    [ `S "DESCRIPTION"
    ; `P
        {|Removes files added by dune such as _build, <package>.install, and .merlin|}
    ; `Blocks Common.help_secs
    ]
  in
  let term =
    let+ common = Common.term in
    (* Pass [No_log_file] to prevent the log file from being created. Indeed, we
       are going to delete the whole build directory right after and that
       includes deleting the log file. Not only creating the log file would be
       useless but with some FS this also causes [dune clean] to fail (cf
       https://github.com/ocaml/dune/issues/2964). *)
    let _config = Common.init common ~log_file:No_log_file in
    Build_system.files_in_source_tree_to_delete ()
    |> Path.Set.iter ~f:Path.unlink_no_err;
    Path.rm_rf Path.build_dir
  in
  (term, Term.info "clean" ~doc ~man)
