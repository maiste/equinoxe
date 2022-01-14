(*****************************************************************************)
(* Open Source License                                                       *)
(* Copyright (c) 2021-present Étienne Marais <etienne@maiste.fr>             *)
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
  (** It is the signature that matches the API of the website. *)

  type 'a io
  type json = Ezjsonm.value

  type t
  (** Abstract type [t] represents the information known by the API system. *)

  val create : ?address:string -> ?token:string -> unit -> t
  (** [create ~address ~token ()] returns an {!t} object, you need to manipulate
      when executing requests. Default [address] is
      [https://api.equinix.com/metal/v1/] and default [token] is empty. *)

  module Auth : sig
    (** This module manages API parts related to authentification. *)

    val get_user_api_keys : t -> json io
    (** [get_user_api_keys t] returns the keys available for the current user. *)

    val post_user_api_keys :
      t -> ?read_only:bool -> description:string -> unit -> json io
    (** [post_user_api_keys t ~read_only ~description ()] creates a new API key
        on Equinix. Default value to read_only is true. *)

    val delete_user_api_keys_id : t -> id:string -> unit -> json io
    (** [delete_user_api_keys_id t ~id () ] deletes the key referenced by [id]
        from the user keys. *)
  end

  module Devices : sig
    (** This module manages API parts related to devices. *)

    (** Actions executable with a device. *)
    type action = Power_on | Power_off | Reboot | Reinstall | Rescue

    (** Os available when creating a new device. *)
    type os =
      | Debian_9
      | Debian_10
      | NixOs_21_05
      | Ubuntu_18_04
      | Ubuntu_20_04
      | Ubuntu_21_04
      | FreeBSD_11_2
      | Centos_8

    (** Locations available when deploying a new device. *)
    type location =
      | Washington
      | Dallas
      | Silicon_valley
      | Sao_paulo
      | Amsterdam
      | Frankfurt
      | Singapore
      | Sydney

    (** Server type when deploying a new device. *)
    type plan = C3_small_x86 | C3_medium_x86

    type config = {
      hostname : string;
      location : location;
      plan : plan;
      os : os;
    }
    (** This type represents the configuration wanted for a device. *)

    val os_to_string : os -> string
    (** [os_to_string os] converts an os into a string understandable by the
        API. *)

    val location_to_string : location -> string
    (** [location_to_string facility] converts a facility into a string
        understandable by the API. *)

    val plan_to_string : plan -> string
    (** [plan_to_string plan] converts a plan into a string understandable by
        the API. *)

    val get_devices_id : t -> id:string -> unit -> json io
    (** [get_devices_id t ~id ()] returns a {!json io} that contains information
        about the device specified by [id]. *)

    val get_devices_id_events : t -> id:string -> unit -> json io
    (** [get_device_id_events t ~id ()] retrieves information about the device
        events. *)

    val post_devices_id_actions :
      t -> id:string -> action:action -> unit -> json io
    (** [post_devices_id_actions t ~id ~action ()] executes an action on the
        device specified by its id. *)

    val delete_devices_id : t -> id:string -> unit -> json io
    (** [delete_devices_id t ~id ()] deletes a device on Equinix and returns a
        {!json io} with the result. *)

    val get_devices_id_ips : t -> id:string -> unit -> json io
    (** [get_devices_id_ips t ~id ()] retrieves information about the device
        ips. *)
  end

  module Ip : sig
    (** This module manages API parts related to ips. *)

    val get_ips_id : t -> id:string -> unit -> json io
    (** [get_ips_id t ~id ()] returns informations about an ip referenced by its
        [id]. *)
  end

  module Orga : sig
    (** This module manages API parts related to organizations. *)

    val get_organizations : t -> json io
    (** [get_organizations t] returns all the organizations associated with the
        token. *)

    val get_organizations_id : t -> id:string -> unit -> json io
    (** [get_organizations_id t ~id ()] returns the {!json io} that is
        referenced by the [id] given in parameter. *)
  end

  module Projects : sig
    (** This module manages API parts related to projects. *)

    val get_projects : t -> json io
    (** [get_projects t] returns all projects associated with the token. *)

    val get_projects_id : t -> id:string -> unit -> json io
    (** [get_projects_id t ~id ()] returns the {!json io} that is referenced by
        the [id] given in parameter. *)

    val get_projects_id_devices : t -> id:string -> unit -> json io
    (** [get_projects_id_devices t ~id ()] returns the {!json io} that contains
        all the devices related to the project [id]. *)

    val post_projects_id_devices :
      t -> id:string -> config:Devices.config -> unit -> json io
    (** [post_projects_id_devicest ~id ~config ()] creates a machine on the
        Equinix with the {!Devices.config} specification *)
  end

  module Users : sig
    (** This module manages API parts related to users. *)

    val get_user : t -> json io
    (** [get_user t] returns information about the user linked to the API key. *)
  end

  module Json : sig
    (** Helper functions to manipulate Json *)

    val ( --> ) : json io -> string -> json io
    val ( |-> ) : json io -> int -> json io
    val to_list : (json -> 'a io) -> json io -> 'a list io
    val to_string : json io -> string io
    val to_unit : json io -> unit io
    val pp_r : json io -> unit io
  end
end

module type Backend = Backend.S

module type Sigs = sig
  (** Equinoxe library interface. *)

  module type API = API

  (** {1 Build your own API} *)

  module type Backend = Backend

  (** Factory to build a system to communicate with Equinix API, using the {!S}
      communication system. *)
  module Make (B : Backend) : API with type 'a io = 'a B.io
end
