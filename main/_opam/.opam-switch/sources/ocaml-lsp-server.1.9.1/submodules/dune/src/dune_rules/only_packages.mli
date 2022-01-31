(** Restrict the set of visible packages *)

open Import

module Clflags : sig
  type t =
    | No_restriction
    | Restrict of
        { names : Package.Name.Set.t
        ; command_line_option : string
              (** Which of [-p], [--only-packages], ... was passed *)
        }

  (** This must be called exactly once *)
  val set : t -> unit
end

type t = Package.t Package.Name.Map.t option

(** Returns the package restrictions. This function is memoized. *)
val get : unit -> t Memo.Build.t
