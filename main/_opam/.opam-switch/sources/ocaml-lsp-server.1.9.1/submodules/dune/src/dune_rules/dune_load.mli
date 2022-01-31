(** Loads dune files from the file system.

    Also responsible for evaluating dune files written in OCaml syntax. *)
open! Dune_engine

open! Stdune

module Dune_files : sig
  (** A partially evaluated dune file. The context's ocamlc is used to evaluate
      dune files in ocaml syntax *)
  type t

  val eval : t -> context:Context.t -> Dune_file.t list Memo.Build.t
end

type conf = private
  { dune_files : Dune_files.t
  ; packages : Package.t Package.Name.Map.t
  ; projects : Dune_project.t list
  }

(** Load all dune files. This function is memoized. *)
val load : unit -> conf Memo.Build.t
