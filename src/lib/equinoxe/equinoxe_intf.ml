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

  exception Unknown_value of string * string
  (** This exception represent an error when the parsing works but the value
      received is unknown. *)

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
    (** [delete_key t ~id ] deletes the key referenced by [id] from the user
        keys. *)

    val pp : config -> unit
    (** [pp config] prints on stdout the [config] given. *)
  end

  module Ip : sig
    (** This module manages API parts related to ips. *)

    type id
    (** Abstract to represent a unique identifier in the Equinix API. *)

    type config = {
      id : id;
      netmask : string;
      network : string;
      address : string;
      gateway : string;
      public : bool;
      enabled : bool;
      created_at : Date.t;
    }
    (** Representation of an Ip. *)

    val id_of_string : string -> id
    (** [id_of_string str] turns a string into an Ip [id]. *)

    val config_of_json : Ezjsonm.value -> config
    (** [config_of_json json] returns a [config] representing the context of the
        JSON.

        @raise Ezjsonm.Parse_error in case of error. *)

    val to_string : config -> string
    (** [to_string config] returns a string that represents the configuration. *)

    val get_from : t -> id:id -> config io
    (** [get_ips_id t ~id] returns informations about an ip referenced by its
        [id]. *)

    val pp : config -> unit
    (** [pp config] prints a [config] in a human readable way. *)
  end

  module Project : sig
    (** This module manages API parts related to projects. *)

    type id
    (** Unique identifier for the Equinix API. *)

    type config = {
      id : id;
      name : string;
      created_at : Date.t;
      updated_at : Date.t;
    }
    (** Representation of an Equinix Project. *)

    val id_of_string : string -> id
    (** [id_of_string str] converts [str] into an [id]. *)

    val string_of_id : id -> string
    (** [string_of_id id] returns the string that represents the [id]. *)

    val to_string : config -> string
    (** [to_string config] returns a string representation of the [config]. *)

    val get_all : t -> config list io
    (** [get_all t] returns all projects associated with the token. *)

    val get_from : t -> id:id -> config io
    (** [get_from t ~id ] returns the {!config} of the project that is
        referenced by the [id] given in parameter. *)

    val pp : config -> unit
    (** [pp config] prints a human readable Project config. *)
  end

  module State : sig
    (** This module represents the state of a Device in the Equinix API. *)

    (** Available state to describe a machine. *)
    type t =
      | Active
      | Queued
      | Provisioning
      | Inactive
      | Powering_off
      | Powering_on

    val of_string : string -> t
    (** [of_string str] returns a state in function of a string. If the state is
        not known, it returns Unknown_state. *)

    val to_string : t -> string
    (** [to_string t] returns a string representation of the state. *)
  end

  module Event : sig
    (** This module deals with events that occures in Equinix. *)

    type id
    (** Unique identifier. *)

    val id_of_string : string -> id
    (** [id_of_string str] returns a string referencing the event in Equinix. *)

    val id_to_string : id -> string
    (** [id_to_string id] returns a string representation of the id. *)

    type t = {
      id : id;
      state : State.t;
      event_type : string;
      body : string;
      created_at : Date.t;
    }
    (** A representation of an event. *)

    val t_of_json : Ezjsonm.value -> t
    (** [t_of_json json] extracts information about event from [json]. *)
  end

  module Devices : sig
    (** This module manages API parts related to devices. *)

    type id
    (** Unique identifier for the Equinix API. *)

    val id_of_string : string -> id
    (** [id_of_string str] creates a unique identifier from [str]. *)

    (** Actions executable with a device. *)
    type action = Power_on | Power_off | Reboot | Reinstall | Rescue

    val action_to_string : action -> string
    (** [action_of_string action] returns a readable action as a string. *)

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
      | Alpine_3

    val os_to_string : os -> string
    (** [os_to_string os] converts an os into a string understandable by the
        API. *)

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

    val location_to_string : location -> string
    (** [location_to_string facility] converts a facility into a string
        understandable by the API. *)

    (** Server type when deploying a new device. *)
    type plan = C3_small_x86 | C3_medium_x86

    val plan_to_string : plan -> string
    (** [plan_to_string plan] converts a plan into a string understandable by
        the API. *)

    type builder
    (** This type represents the configuration wanted for a device. *)

    type setter = Hostname of string  (** Option to extend the builder. *)

    val set_builder : builder -> setter -> builder
    (** [set_builder builder setter] extends the builder with the option. *)

    val ( |+ ) : builder -> setter -> builder
    (** [builder |+ setter] is an infix operator for {!set_builder}. *)

    val build : plan -> os -> location -> builder
    (* [build plan os locatation] returns a build with the minimal configuration required. *)

    type config = {
      id : id;
      hostname : string;
      location : location;
      plan : plan;
      os : os;
      state : State.t;
      tags : string list;
      user : string;
      created_at : Date.t;
      ips : Ip.config list;
    }
    (** This type represents the current configuration for the device. [ips] can
        be empty. *)

    val to_string : config -> string
    (** [to_string config] returns a readable string containing the config. *)

    val get_from : t -> id:id -> config io
    (** [get_devices_id t ~id ()] returns a {!config} that contains information
        about the device specified by [id]. *)

    val get_events_from : t -> id:id -> Event.t list io
    (** [get_device_id_events t ~id ()] retrieves information about the device
        events. *)

    val execute_action_on : t -> id:id -> action:action -> unit io
    (** [post_devices_id_actions t ~id ~action ()] executes an action on the
        device specified by its id. *)

    val delete : t -> id:id -> ?force:bool -> unit -> unit io
    (** [delete_devices_id t ~id ~force ()] deletes a device on Equinix and
        returns a {!json} with the result. [?force] defaults to [false], if
        [true] then it forces the deletion of the device by detaching any
        storage volume still active. *)

    val create : t -> id:Project.id -> builder -> config io
    (** [post_projects_id_devicest ~id ~config ()] creates a machine on the
        Equinix with the {!Devices.config} specification. *)

    val get_all_from_project : t -> id:Project.id -> config list io
    (** [get_projects_id_devices t ~id] returns the {!json} that contains all
        the devices related to the project [id]. *)

    val pp : config -> unit
    (** [pp config] prints a readable string representing the config. *)
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
