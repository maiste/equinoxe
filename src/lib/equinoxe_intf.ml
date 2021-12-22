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

module type API = sig
  (** It is the signature of the API of the website. *)

  type t
  (** Abstract type [t] represents the information known by the API system. *)

  val create :
    endpoint:string ->
    ?token:[ `Default | `Str of string | `Path of string ] ->
    unit ->
    t
  (** [create opts] returns an {!t} object, you need to manipulate when
      executing requests. *)

  module Auth : sig
    (** This module manages API part related to authentifications. *)

    val get_user_api_keys : t -> Json.t
    (** [get_user_api_keys t] returns the keys available for the current user. *)

    val post_user_api_keys :
      t -> ?read_only:bool -> description:string -> unit -> Json.t
    (** [post_user_api_keys ~read_only ~description ()] creates a new API key on
        Equinix. Default value to read_only is true. *)

    val del_user_api_keys_id : t -> id:string -> unit -> Json.t
    (** [del_user_api_keys_id t ~id () ] deletes the key referenced by [id] from
        the user keys. *)
  end

  module Orga : sig
    (** This module manages API part related to organizations. *)

    val get_organizations : t -> Json.t
    (** [get_organizations t] returns an all the organizations associated with
        the token. *)

    val get_organizations_id : t -> id:string -> unit -> Json.t
    (** [get_organizations_id t ~id ()] returns the {!Json.t} that is referenced
        by the id given in parameter. *)
  end

  module Users : sig
    (** This module manages API part related to users. *)

    val get_user : t -> Json.t
    (** [get_user t] returns informations about the user linked to the API key. *)
  end

  module Metal : sig end
end

module type S = CallAPI.S

module type Sigs = sig
  (** Equinoxe library interface. *)

  (** {1 Manipulate Results} *)

  module Json = Json

  module type API = API

  (** {1 Build your own API} *)

  module type S = S

  module Default_api : S

  (** Factory to build a system to communicate with Equinix API, using the {!S}
      communication system. *)
  module Make (C : S) : API
end
