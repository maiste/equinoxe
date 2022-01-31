(** Actions as they are written in dune files. *)
open! Dune_engine

open Stdune

include module type of struct
    (** The type definition exists in [Action_dune_lang] and not here to break
        cycles.*)
    include Action_dune_lang
  end
  (* We don't want to leak ugly aliases *)
  with type program := String_with_vars.t
   and type string := String_with_vars.t
   and type path := String_with_vars.t
   and type target := String_with_vars.t

val remove_locs : t -> t

(** Expand an action and return its target and dependencies.

    Expanding an action substitutes all [%{..}] forms, discovers dependencies
    and targets, and verifies invariants such as:

    - All the targets are in [targets_dir]
    - The [targets] mode is respected

    [foreign_flags] has to be passed because it depends on [Super_context].
    Fetching it directly would introduce a dependency cycle. *)
val expand :
     t
  -> loc:Loc.t
  -> deps:Dep_conf.t Bindings.t
  -> targets_dir:Path.Build.t
  -> targets:Path.Build.t Targets.t
  -> expander:Expander.t
  -> Action.t Action_builder.With_targets.t Memo.Build.t

(** [what] as the same meaning as the argument of
    [Expander.Expanding_what.User_action_without_targets] *)
val expand_no_targets :
     t
  -> loc:Loc.t
  -> deps:Dep_conf.t Bindings.t
  -> expander:Expander.t
  -> what:string
  -> Action.t Action_builder.t
