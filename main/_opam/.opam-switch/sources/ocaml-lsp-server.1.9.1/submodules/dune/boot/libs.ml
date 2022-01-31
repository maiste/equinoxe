let executables = [ "main" ]

let external_libraries = [ "unix"; "threads.posix" ]

let local_libraries =
  [ ("vendor/pp/src", Some "Pp", false, None)
  ; ("otherlibs/dyn", Some "Dyn", false, None)
  ; ("vendor/csexp/src", Some "Csexp", false, None)
  ; ("otherlibs/stdune-unstable/dune_filesystem_stubs",
    Some "Dune_filesystem_stubs", false, None)
  ; ("otherlibs/stdune-unstable", Some "Stdune", false, None)
  ; ("src/dune_lang", Some "Dune_lang", false, None)
  ; ("vendor/incremental-cycles/src", Some "Incremental_cycles", false, None)
  ; ("src/dag", Some "Dag", false, None)
  ; ("src/fiber", Some "Fiber", false, None)
  ; ("src/memo", Some "Memo", false, None)
  ; ("otherlibs/xdg", Some "Xdg", false, None)
  ; ("src/dune_util", Some "Dune_util", false, None)
  ; ("src/dune_cache_storage", Some "Dune_cache_storage", false, None)
  ; ("src/dune_cache", Some "Dune_cache", false, None)
  ; ("vendor/re/src", Some "Dune_re", false, None)
  ; ("vendor/opam-file-format/src", None, false, None)
  ; ("otherlibs/dune-glob/src", Some "Dune_glob", false, None)
  ; ("src/ocaml-config", Some "Ocaml_config", false, None)
  ; ("otherlibs/action-plugin/src", Some "Dune_action_plugin", false, None)
  ; ("src/chrome_trace", Some "Chrome_trace", false, None)
  ; ("vendor/spawn/src", Some "Spawn", false, None)
  ; ("src/dune_stats", Some "Dune_stats", false, None)
  ; ("src/meta_parser", Some "Dune_meta_parser", false, None)
  ; ("src/section", Some "Dune_section", false, None)
  ; ("vendor/build_path_prefix_map/src", Some "Build_path_prefix_map", false,
    None)
  ; ("otherlibs/dune-rpc/private", Some "Dune_rpc_private", false, None)
  ; ("src/dune_rpc_server", Some "Dune_rpc_server", false, None)
  ; ("src/thread_worker", Some "Thread_worker", false, None)
  ; ("src/ocamlc_loc", Some "Ocamlc_loc", false, None)
  ; ("vendor/ocaml-inotify/src", Some "Ocaml_inotify", false, None)
  ; ("src/async_inotify_for_dune", Some "Async_inotify_for_dune", false,
    None)
  ; ("src/dune_file_watcher", Some "Dune_file_watcher", false, None)
  ; ("src/dune_engine", Some "Dune_engine", false, None)
  ; ("src/dune_config", Some "Dune_config", false, None)
  ; ("src/dune_rules", Some "Dune_rules", true, None)
  ; ("src/upgrader", Some "Dune_upgrader", false, None)
  ; ("vendor/cmdliner/src", None, false, None)
  ; ("otherlibs/build-info/src", Some "Build_info", false,
    Some "Build_info_data")
  ; ("src/csexp_rpc", Some "Csexp_rpc", false, None)
  ; ("src/dune_rpc_impl", Some "Dune_rpc_impl", false, None)
  ]
