(** Functions on paths that are represented as strings *)

type mkdir_result =
  | Already_exists  (** The directory already exists. No action was taken. *)
  | Created  (** The directory was created. *)
  | Missing_parent_directory
      (** No parent directory, use [mkdir_p] if you want to create it too. *)

val mkdir : ?perms:int -> string -> mkdir_result

type mkdir_p_result =
  | Already_exists  (** The directory already exists. No action was taken. *)
  | Created  (** The directory was created. *)

val mkdir_p : ?perms:int -> string -> mkdir_p_result

type follow_symlink_error =
  | Not_a_symlink
  | Max_depth_exceeded
  | Unix_error of Unix.error

val follow_symlink : string -> (string, follow_symlink_error) result

val unlink : string -> unit

val unlink_no_err : string -> unit

val initial_cwd : string

type clear_dir_result =
  | Cleared
  | Directory_does_not_exist

val clear_dir : string -> clear_dir_result

(** If the path does not exist, this function is a no-op. *)
val rm_rf : ?allow_external:bool -> string -> unit

val is_root : string -> bool
