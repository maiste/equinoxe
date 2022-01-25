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
  (** @deprecated It is the signature that matches the API of the website. *)

  type 'a io
  type json = Ezjsonm.value

  type t
  (** Abstract type [t] represents the information known by the API system. *)

  val create : ?address:string -> ?token:string -> unit -> t
  (** [create ~address ~token ()] returns an {!t} object, you need to manipulate
      when executing requests. Default [address] is
      [https://api.equinix.com/metal/v1/] and default [token] is empty. *)

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
    (** [get_devices_id t ~id ()] returns a {!json} that contains information
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
        {!json} with the result. *)

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

  module Projects : sig
    (** This module manages API parts related to projects. *)

    val get_projects : t -> json io
    (** [get_projects t] returns all projects associated with the token. *)

    val get_projects_id : t -> id:string -> unit -> json io
    (** [get_projects_id t ~id ()] returns the {!json} that is referenced by the
        [id] given in parameter. *)

    val get_projects_id_devices : t -> id:string -> unit -> json io
    (** [get_projects_id_devices t ~id ()] returns the {!json} that contains all
        the devices related to the project [id]. *)

    val post_projects_id_devices :
      t -> id:string -> config:Devices.config -> unit -> json io
    (** [post_projects_id_devicest ~id ~config ()] creates a machine on the
        Equinix with the {!Devices.config} specification *)
  end
end

module Date = ODate.Unix
(** Module to manipulate dates in the API. *)

module type FRIENDLY_API = sig
  (** It offers OCaml types to manipulate the Equinix API. *)

  type 'a io

  type t
  (** Abstract type [t] represents the information known by the API system. *)

  val create : ?address:string -> ?token:string -> unit -> t
  (** [create ~address ~token ()] returns an {!t} object, you need to manipulate
      when executing requests. Default [address] is
      [https://api.equinix.com/metal/v1/] and default [token] is empty. *)

  module Orga : sig
    (** A module to interact with Equinix organization. *)

    type id
    (** The unique indentifier for the an organization. *)

    type config = {
      id : id;
      name : string;
      account_id : string;
      website : string;
      maintenance_email : string;
      max_projects : int;
    }
    (** Type that represents an organization configuration. *)

    val id_of_string : string -> id
    (** [id_of_string str] creates an id from a string from the Equinix API. *)

    val to_string : config -> string
    (** [to_string config] returns a string representing an organization
        configuration. *)

    val get_from : t -> id -> config io
    (** [get_from t id] returns an organization configuration associated with
        the [id] given. *)

    val get_all : t -> config list io
    (** [get_all t] return all the organization associated with the [t] api
        token. *)

    val pp : config -> unit
    (** [pp config] pretty-prints an organization configuration. *)
  end

  module Users : sig
    (** A module to interact with Equinix users. *)

    type id
    (** A unique identifier for a user. *)

    type config = {
      id : id;
      first_name : string;
      last_name : string;
      email : string;
      created_at : Date.t;
      last_login_at : Date.t;
    }
    (** Representation of a user configuration. *)

    val id_of_string : string -> id
    (* [id_of_string str] creates an id from a string from the Equinix API. *)

    val to_string : config -> string
    (** [to_string config] returns a string representing a user. *)

    val get_current_user : t -> config io
    (** [get_current_user t] returns the user interacting with the API. *)

    val pp : config -> unit
    (** [pp config] pretty-prints a user configuration. *)
  end

  module Auth : sig
    (** This module manages API parts related to authentification. *)

    type id
    (** Unique identifier to represent a key in the Equinix API *)

    type config = {
      id : id;
      token : string;
      read_only : bool;
      created_at : Date.t;
      description : string;
    }
    (** Representation of an API key *)

    val id_of_string : string -> id
    (** [id_of_string str] returns a unique identifier from the Equinix API *)

    val to_string : config -> string
    (** [to_string config] returns a string representating an API key. *)

    val get_keys : t -> config list io
    (** [get_keys t] returns the keys available for the current user. *)

    val create_key :
      t -> ?read_only:bool -> description:string -> unit -> config io
    (** [create_key t ~read_only ~description ()] creates a new API key on
        Equinix. Default value to read_only is true. *)

    val delete_key : t -> id:id -> unit io
    (** [delete_key t ~id () ] deletes the key referenced by [id] from the user
        keys. *)

    val pp : config -> unit
    (** [pp config] prints on stdout the [config] given. *)
  end
end

module type Backend = Backend.S

module type Sigs = sig
  (** Equinoxe library interface. *)

  module type API = API
  module type FRIENDLY_API = FRIENDLY_API

  (** {1 Build your own API} *)

  module type Backend = Backend

  (** Factory to build a system to communicate with Equinix API, using the
      {!Backend} communication system. *)
  module Make (B : Backend) : API with type 'a io = 'a B.io

  (** Factory to build a system to communicate with Equinix API in a
      strongly-typed way using the {!Backend} gathering system. *)
  module MakeFriendly (B : Backend) : FRIENDLY_API with type 'a io = 'a B.io
end
