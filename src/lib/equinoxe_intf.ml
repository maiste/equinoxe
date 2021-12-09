(*****************************************************************************)
(* Open Source License                                                       *)
(* Copyright (c) 2021 Étienne Marais <etienne@maiste.fr>                     *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *)
(* DEALINGS IN THE SOFTWARE.                                                 *)
(*                                                                           *)
(*****************************************************************************)

open Utils

(** [API] provides functionnalities to interface with Equinix. *)
module type API = sig
  type t
  (** Abstract type [t] represents the information known by the API system. *)

  val create :
    endpoint:string ->
    ?token:[ `Default | `Str of string | `Path of string ] ->
    unit ->
    t
  (** [create opts] returns an {!t} object, you need to manipulate when
      executing requests. *)

  (** This module manages API part related to the user. *)
  module Users : sig
    val get_current_user : t -> Json.t
    (** [get_current_user] returns informations about the user linked to the API
        key. *)

    val get_user_api_keys : t -> Json.t
    (** [get_user_api_keys] returns the keys available for the current user. *)
  end

  module Orga : sig end
  module Metal : sig end
end

module type Sigs = sig
  module Json : sig
    (** Utilities for Equinoxe-cli. *)
    include module type of Json
    (** @inline *)
  end

  module Ezcurl_api : CallAPI.S
  (** Provides an {!Ezcurl} api for equinoxe. *)

  (** Factory to build a system to communicate with Equinix API, using the
      {!CallAPI} communication system. *)
  module Make (C : CallAPI.S) : API
end
