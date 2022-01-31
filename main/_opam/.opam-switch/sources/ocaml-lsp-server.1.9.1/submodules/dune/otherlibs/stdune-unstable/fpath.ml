let is_root t = Filename.dirname t = t

let initial_cwd = Stdlib.Sys.getcwd ()

type mkdir_result =
  | Already_exists
  | Created
  | Missing_parent_directory

let mkdir ?(perms = 0o777) t_s =
  try
    Unix.mkdir t_s perms;
    Created
  with
  | Unix.Unix_error (EEXIST, _, _) -> Already_exists
  | Unix.Unix_error (ENOENT, _, _) -> Missing_parent_directory

type mkdir_p_result =
  | Already_exists
  | Created

let rec mkdir_p ?(perms = 0o777) t_s =
  match mkdir ~perms t_s with
  | Created -> Created
  | Already_exists -> Already_exists
  | Missing_parent_directory -> (
    if is_root t_s then
      Code_error.raise
        "Impossible happened: [Fpath.mkdir] refused to create a directory at \
         the root, allegedly because its parent was missing"
        []
    else
      let parent = Filename.dirname t_s in
      match mkdir_p ~perms parent with
      | Created
      | Already_exists ->
        (* The [Already_exists] case might happen if some other process managed
           to create the parent directory concurrently. *)
        Unix.mkdir t_s perms;
        Created)

let resolve_link path =
  match Unix.readlink path with
  | exception Unix.Unix_error (EINVAL, _, _) -> Ok None
  | exception Unix.Unix_error (e, _, _) -> Error e
  | link ->
    Ok
      (Some
         (if Filename.is_relative link then
           Filename.concat (Filename.dirname path) link
         else
           link))

type follow_symlink_error =
  | Not_a_symlink
  | Max_depth_exceeded
  | Unix_error of Unix.error

let follow_symlink path =
  let rec loop n path =
    if n = 0 then
      Error Max_depth_exceeded
    else
      match resolve_link path with
      | Error e -> Error (Unix_error e)
      | Ok None -> Ok path
      | Ok (Some path) -> loop (n - 1) path
  in
  match resolve_link path with
  | Ok None -> Error Not_a_symlink
  | Ok (Some p) -> loop 20 p
  | Error e -> Error (Unix_error e)

let win32_unlink fn =
  try Unix.unlink fn with
  | Unix.Unix_error (Unix.EACCES, _, _) as e -> (
    try
      (* Try removing the read-only attribute *)
      Unix.chmod fn 0o666;
      Unix.unlink fn
    with
    | _ -> raise e)

let unlink =
  if Stdlib.Sys.win32 then
    win32_unlink
  else
    Unix.unlink

let unlink_no_err t =
  try unlink t with
  | _ -> ()

type clear_dir_result =
  | Cleared
  | Directory_does_not_exist

let rec clear_dir dir =
  match Dune_filesystem_stubs.read_directory_with_kinds dir with
  | Error ENOENT -> Directory_does_not_exist
  | Error error ->
    raise
      (Unix.Unix_error
         (error, dir, "Stdune.Path.rm_rf: read_directory_with_kinds"))
  | Ok listing ->
    List.iter listing ~f:(fun (fn, kind) ->
        let fn = Filename.concat dir fn in
        (* Note that by the time we reach this point, [fn] might have been
           deleted by a concurrent process. Both [rm_rf_dir] and [unlink_no_err]
           will tolerate such phantom paths and succeed. *)
        match kind with
        | Unix.S_DIR -> rm_rf_dir fn
        | _ -> unlink_no_err fn);
    Cleared

and rm_rf_dir path =
  match clear_dir path with
  | Directory_does_not_exist -> ()
  | Cleared -> (
    match Unix.rmdir path with
    | () -> ()
    | exception Unix.Unix_error (ENOENT, _, _) ->
      (* How can we end up here? [clear_dir] cleared the directory successfully,
         but by the time the above [Unix.rmdir] was called, another process
         deleted the directory. *)
      ())

let rm_rf ?(allow_external = false) fn =
  if (not allow_external) && not (Filename.is_relative fn) then
    Code_error.raise "Path.rm_rf called on external dir" [ ("fn", String fn) ];
  match Unix.lstat fn with
  | exception Unix.Unix_error (ENOENT, _, _) -> ()
  | { Unix.st_kind = S_DIR; _ } -> rm_rf_dir fn
  | _ -> unlink fn
