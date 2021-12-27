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

    val delete_user_api_keys_id : t -> id:string -> unit -> Json.t
    (** [delete_user_api_keys_id t ~id () ] deletes the key referenced by [id]
        from the user keys. *)
  end

  module Devices : sig
    (** This module manages API part related to devices. *)

    type action = Power_on | Power_off | Reboot | Reinstall | Rescue

    type config = {
      facility : string;
      plan : string;
      operating_system : string;
    }
    (** This type represents the configuration wanted for a device. *)

    val get_devices_id : t -> id:string -> unit -> Json.t
    (** [get_devices_id t ~id ()] returns a {!Json.t} that contains information
        about the device specified by [id]. *)

    val get_devices_id_events : t -> id:string -> unit -> Json.t
    (** [get_device_id_events t ~id ()] retrieves information about the device
        events. *)

    val post_devices_id_actions :
      t -> id:string -> action:action -> unit -> Json.t
    (** [post_devices_id_actions t ~id ~action ()] executes an action on the
        device specified by its id. *)

    val delete_devices_id : t -> id:string -> unit -> Json.t
    (** [delete_devices_id t ~id ()] deletes a device on Equinix and returns a
        {!Json.t} with the result. *)
  end

  module Orga : sig
    (** This module manages API part related to organizations. *)

    val get_organizations : t -> Json.t
    (** [get_organizations t] returns all the organizations associated with the
        token. *)

    val get_organizations_id : t -> id:string -> unit -> Json.t
    (** [get_organizations_id t ~id ()] returns the {!Json.t} that is referenced
        by the [id] given in parameter. *)
  end

  module Projects : sig
    (** This module manages API part related to projects. *)

    val get_projects : t -> Json.t
    (** [get_projects t] returns all projects associated with the token. *)

    val get_projects_id : t -> id:string -> unit -> Json.t
    (** [get_projects_id t ~id ()] returns the {!Json.t} that is referenced by
        the [id] given in parameter. *)

    val get_projects_id_devices : t -> id:string -> unit -> Json.t
    (** [get_projects_id_devices t ~id ()] returns the {!Json.t} that contains
        all the devices related to the project [id]. *)

    val post_projects_id_devices :
      t -> id:string -> config:Devices.config -> unit -> Json.t
    (** [post_projects_id_devicest ~id ~config ()] creates a machine on the
        Equinix with the {!Devices.config} specification *)
  end

  module Users : sig
    (** This module manages API part related to users. *)

    val get_user : t -> Json.t
    (** [get_user t] returns informations about the user linked to the API key. *)
  end
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
