open Stdune
open Import

let doc =
  "Execute a command in a similar environment as if installation was performed."

let man =
  [ `S "DESCRIPTION"
  ; `P
      {|$(b,dune exec -- COMMAND) should behave in the same way as if you
          do:|}
  ; `Pre "  \\$ dune install\n  \\$ COMMAND"
  ; `P
      {|In particular if you run $(b,dune exec ocaml), you will have
          access to the libraries defined in the workspace using your usual
          directives ($(b,#require) for instance)|}
  ; `P
      {|When a leading / is present in the command (absolute path), then the
          path is interpreted as an absolute path|}
  ; `P
      {|When a / is present at any other position (relative path), then the
          path is interpreted as relative to the build context + current
          working directory (or the value of $(b,--root) when ran outside of
          the project root)|}
  ; `Blocks Common.help_secs
  ; Common.examples
      [ ("Run the executable named `my_exec'", "dune exec my_exec")
      ; ( "Run the executable defined in `foo.ml' with the argument `arg'"
        , "dune exec -- ./foo.exe arg" )
      ]
  ]

let info = Term.info "exec" ~doc ~man

let term =
  let+ common = Common.term
  and+ context =
    Common.context_arg ~doc:{|Run the command in this build context.|}
  and+ prog =
    Arg.(required & pos 0 (some string) None (Arg.info [] ~docv:"PROG"))
  and+ no_rebuild =
    Arg.(
      value & flag
      & info [ "no-build" ] ~doc:"don't rebuild target before executing")
  and+ args = Arg.(value & pos_right 0 string [] (Arg.info [] ~docv:"ARGS")) in
  let config = Common.init common in
  Scheduler.go ~common ~config (fun () ->
      let open Fiber.O in
      let* setup = Import.Main.setup () in
      let* setup = Memo.Build.run setup in
      let sctx = Import.Main.find_scontext_exn setup ~name:context in
      let context = Dune_rules.Super_context.context sctx in
      let dir =
        Path.Build.relative context.build_dir (Common.prefix_target common "")
      in
      let build_prog p =
        let open Memo.Build.O in
        if no_rebuild then
          if Path.exists p then
            Memo.Build.return p
          else
            User_error.raise
              [ Pp.textf
                  "Program %S isn't built yet. You need to build it first or \
                   remove the --no-build option."
                  prog
              ]
        else
          let+ _digest = Build_system.build_file p in
          p
      in
      let not_found () =
        let open Memo.Build.O in
        let+ hints =
          (* Good candidates for the "./x.exe" instead of "x.exe" error are
             executables present in the current directory *)
          let+ candidates =
            Build_system.targets_of ~dir:(Path.build dir)
            >>| Path.Set.to_list
            >>| List.filter ~f:(fun p -> Path.extension p = ".exe")
            >>| List.map ~f:(fun p -> "./" ^ Path.basename p)
          in
          User_message.did_you_mean prog ~candidates
        in
        User_error.raise ~hints [ Pp.textf "Program %S not found!" prog ]
      in
      let* prog =
        let open Memo.Build.O in
        Build_system.run_exn (fun () ->
            match Filename.analyze_program_name prog with
            | In_path -> (
              Super_context.resolve_program sctx ~dir ~loc:None prog
              >>= function
              | Error (_ : Action.Prog.Not_found.t) -> not_found ()
              | Ok prog -> build_prog prog)
            | Relative_to_current_dir -> (
              let path = Path.relative (Path.build dir) prog in
              (Build_system.is_target path >>= function
               | true -> Memo.Build.return (Some path)
               | false -> (
                 if not (Filename.check_suffix prog ".exe") then
                   Memo.Build.return None
                 else
                   let path = Path.extend_basename path ~suffix:".exe" in
                   Build_system.is_target path >>= function
                   | true -> Memo.Build.return (Some path)
                   | false -> Memo.Build.return None))
              >>= function
              | Some path -> build_prog path
              | None -> not_found ())
            | Absolute -> (
              match
                let prog = Path.of_string prog in
                if Path.exists prog then
                  Some prog
                else if not Sys.win32 then
                  None
                else
                  let prog = Path.extend_basename prog ~suffix:Bin.exe in
                  Option.some_if (Path.exists prog) prog
              with
              | Some prog -> Memo.Build.return prog
              | None -> not_found ()))
      in
      let prog = Path.to_string prog in
      let argv = prog :: args in
      restore_cwd_and_execve common prog argv (Super_context.context_env sctx))

let command = (term, info)
