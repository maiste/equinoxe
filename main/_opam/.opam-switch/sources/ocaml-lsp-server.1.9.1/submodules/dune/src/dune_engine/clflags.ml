module Promote = struct
  type t =
    | Automatically
    | Never
end

let report_errors_config = ref Report_errors_config.default

let debug_findlib = ref false

let debug_artifact_substitution = ref false

let debug_digests = ref false

let wait_for_filesystem_clock = ref false

let capture_outputs = ref true

let debug_backtraces b =
  Dune_util.Report_error.report_backtraces b;
  Memo.Debug.track_locations_of_lazy_values := b

let diff_command = ref None

let promote = ref None

let force = ref false

let watch = ref Watch_mode_config.No

let no_print_directory = ref false

let store_orig_src_dir = ref false

let always_show_command_line = ref false

let promote_install_files = ref false

let ignore_promoted_rules = ref false
