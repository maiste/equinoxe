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

include Equinoxe_intf

(* Functor to build API using a specific call API system. *)
module Make (B : Backend) : API with type 'a io = 'a B.io = struct
  type 'a io = 'a B.io
  type t = { address : string; token : string }

  exception Unknown_value of string * string

  let () =
    Printexc.register_printer (function
      | Unknown_value (name, v) ->
          Some
            (Format.sprintf "Internal error: %s got an unknown value (%s)" name
               v)
      | _ -> None)

  let create ?(address = "https://api.equinix.com/metal/v1/") ?(token = "") () =
    { address; token }

  let return x = B.return x
  let ( let* ) m f = B.bind f m
  let fail msg = B.fail (`Msg msg)

  let access field json =
    try Ezjsonm.find json [ field ]
    with Not_found ->
      raise
        (Ezjsonm.Parse_error
           (`String field, Format.sprintf "access: field %s not found" field))

  let fail_with_parsing ~name ~err ~json v =
    let msg =
      Format.sprintf "%s: parse error %s with %s on %s" name err
        (Ezjsonm.value_to_string v)
        (Ezjsonm.value_to_string ~minify:false json)
    in
    fail msg

  let replace_empty s = if s = "" then "<empty>" else s

  let get_date ~name parsable_string =
    try Date.Parser.from_iso parsable_string
    with Failure _ ->
      raise
        (Ezjsonm.Parse_error
           ( `String parsable_string,
             Format.sprintf "%s: Date.Parser.from_iso can't parse date" name ))

  module Http = struct
    let url ~t ~path = Filename.concat t.address path

    let headers ~token =
      let token = if token = "" then [] else [ ("X-Auth-Token", token) ] in
      token @ [ ("Content-Type", "application/json") ]

    let json_of_string str =
      match Ezjsonm.from_string str with
      | json -> return json
      | exception Ezjsonm.Parse_error (_, msg) -> fail msg

    let get_json = function
      | "" -> return (`O [])
      | str -> (
          let* json = json_of_string str in
          match Ezjsonm.find json [ "error" ] with
          | errors ->
              let msg =
                Format.sprintf "The API returns the following error: %s"
                  (Ezjsonm.value_to_string errors)
              in
              fail msg
          | exception Not_found -> return json)

    let request ~t ~path http_request =
      http_request ~headers:(headers ~token:t.token) ~url:(url ~t ~path)

    let run ~t ~path http_request =
      let* body = request ~t ~path http_request in
      get_json body

    let run_with_body ~t ~path http_request body =
      let* body = request ~t ~path http_request body in
      get_json body

    let get = run B.get
    let post_empty = run_with_body B.post ""
    let post json = run_with_body B.post (Ezjsonm.value_to_string json)
    let put json = run_with_body B.put (Ezjsonm.value_to_string json)
    let delete = run B.delete
  end

  module Orga = struct
    type id = string

    type config = {
      id : id;
      name : string;
      account_id : string;
      website : string;
      maintenance_email : string;
      max_projects : int;
    }

    let id_of_string id = id

    let config_of_json json =
      {
        name = access "name" json |> Ezjsonm.get_string;
        id = access "id" json |> Ezjsonm.get_string;
        account_id = access "account_id" json |> Ezjsonm.get_string;
        website = access "website" json |> Ezjsonm.get_string;
        maintenance_email =
          access "maintenance_email" json |> Ezjsonm.get_string;
        max_projects = access "max_projects" json |> Ezjsonm.get_int;
      }

    let to_string config =
      Format.sprintf
        "{\n\
         \tname: %s;\n\
         \tid: %s;\n\
         \taccount_id: %s;\n\
         \twebsite: %s;\n\
         \tmaintenance_email: %s;\n\
         \tmax_projects: %d;\n\
         }"
        (replace_empty config.id)
        (replace_empty config.account_id)
        (replace_empty config.name)
        (replace_empty config.website)
        (replace_empty config.maintenance_email)
        config.max_projects

    let get_from t id =
      let path = Filename.concat "organizations" id in
      let* json = Http.get ~t ~path in
      try
        let organization = config_of_json json in
        return organization
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"get" ~err ~json v

    let get_all t =
      let* json = Http.get ~t ~path:"organizations" in
      try
        let organizations =
          access "organizations" json |> Ezjsonm.get_list config_of_json
        in
        return organizations
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Orga.get_all" ~err ~json v

    let pp config = Format.printf "%s\n" (to_string config)
  end

  module User = struct
    type id = string

    type config = {
      id : id;
      first_name : string;
      last_name : string;
      email : string;
      created_at : Date.t;
      last_login_at : Date.t;
    }

    let id_of_string id = id

    let config_of_json json =
      {
        id = access "id" json |> Ezjsonm.get_string;
        first_name = access "first_name" json |> Ezjsonm.get_string;
        last_name = access "last_name" json |> Ezjsonm.get_string;
        email = access "email" json |> Ezjsonm.get_string;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"User.config_of_json";
        last_login_at =
          access "last_login_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"User.config_of_json";
      }

    let to_string config =
      let created_at = Date.Printer.to_iso config.created_at in
      let last_login_at = Date.Printer.to_iso config.last_login_at in
      Format.sprintf
        "{\n\
         \tid: %s;\n\
         \tfirst_name: %s;\n\
         \tlast_name: %s;\n\
         \temail: %s;\n\
         \tcreate_at: %s;\n\
         \tlast_login_at: %s;\n\
         }"
        (replace_empty config.id)
        (replace_empty config.first_name)
        (replace_empty config.last_name)
        (replace_empty config.email)
        created_at last_login_at

    let get_current_user t =
      let* json = Http.get ~t ~path:"user" in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"User.get_current_user" ~err ~json v

    let pp config = Format.printf "%s\n" (to_string config)
  end

  module Auth = struct
    type id = string

    type config = {
      id : id;
      token : string;
      read_only : bool;
      created_at : Date.t;
      description : string;
    }

    let id_of_string id = id

    let config_of_json json =
      {
        id = access "id" json |> Ezjsonm.get_string;
        token = access "token" json |> Ezjsonm.get_string;
        read_only = access "read_only" json |> Ezjsonm.get_bool;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Auth.config_of_json";
        description = access "description" json |> Ezjsonm.get_string;
      }

    let to_string config =
      let created_at = Date.Printer.to_iso config.created_at in
      Format.sprintf
        "{\n\
         \tid: %s;\n\
         \ttoken: %s;\n\
         \tread_only: %b;\n\
         \tcreate_at: %s;\n\
         description: %s;\n\
         }"
        (replace_empty config.id)
        (replace_empty config.token)
        config.read_only created_at
        (replace_empty config.description)

    let get_keys t =
      let* json = Http.get ~t ~path:"user/api-keys" in
      try
        let keys = access "api_keys" json |> Ezjsonm.get_list config_of_json in
        return keys
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Auth.get_keys" ~err ~json v

    let create_key t ?(read_only = true) ~description () =
      let json =
        `O
          [
            ("read_only", `Bool read_only); ("description", `String description);
          ]
      in
      let* resp = Http.post ~t ~path:"user/api-keys" json in
      try return (config_of_json resp)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Auth.create_key" ~err ~json v

    let delete_key t ~id =
      let path = Filename.concat "user/api-keys/" id in
      let* _json = Http.delete ~t ~path in
      return ()

    let pp config = Format.printf "%s\n" (to_string config)
  end

  module Ip = struct
    type id = string

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

    let id_of_string id = id

    let to_string config =
      let created_at = Date.Printer.to_iso config.created_at in
      Format.sprintf
        "{\n\
         \tid: %s;\n\
         \tnetmask: %s;\n\
         \tnetwork: %s;\n\
         \taddress: %s;\n\
         \tgateway: %s;\n\
         \tpublic: %b;\n\
         \tenabled: %b;\n\
         \tcreate_at: %s;\n\
         }"
        (replace_empty config.id)
        (replace_empty config.netmask)
        (replace_empty config.network)
        (replace_empty config.address)
        (replace_empty config.gateway)
        config.public config.enabled created_at

    let config_of_json json =
      {
        id = access "id" json |> Ezjsonm.get_string;
        netmask = access "netmask" json |> Ezjsonm.get_string;
        network = access "network" json |> Ezjsonm.get_string;
        address = access "address" json |> Ezjsonm.get_string;
        gateway = access "gateway" json |> Ezjsonm.get_string;
        public = access "public" json |> Ezjsonm.get_bool;
        enabled = access "enabled" json |> Ezjsonm.get_bool;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Ip.config_of_json";
      }

    let get_from t ~id =
      let path = Filename.concat "ips" id in
      let* json = Http.get ~t ~path in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Ip.get_from" ~err ~json v

    let pp config = Format.printf "%s\n" (to_string config)
  end

  module Project = struct
    type id = string

    type config = {
      id : id;
      name : string;
      created_at : Date.t;
      updated_at : Date.t;
    }

    let id_of_string id = id
    let string_of_id id = id

    let config_of_json json =
      {
        id = access "id" json |> Ezjsonm.get_string;
        name = access "name" json |> Ezjsonm.get_string;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Project.config_of_json";
        updated_at =
          access "updated_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Project.config_of_json";
      }

    let to_string config =
      let created_at = Date.Printer.to_iso config.created_at in
      let updated_at = Date.Printer.to_iso config.updated_at in
      Format.sprintf
        "{\n\tid: %s;\n\tname: %s;\n\tcreated_at: %s;\n\tupdated_at: %s;\n}"
        (replace_empty config.id)
        (replace_empty config.name)
        created_at updated_at

    let get_all t =
      let* json = Http.get ~t ~path:"projects" in
      try
        let projects =
          access "projects" json |> Ezjsonm.get_list config_of_json
        in
        return projects
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Project.get_all" ~err ~json v

    let get_from t ~id =
      let path = Filename.concat "projects" id in
      let* json = Http.get ~t ~path in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Project.get_from" ~err ~json v

    let pp config = Format.printf "%s\n" (to_string config)
  end

  module State = struct
    type t =
      | Active
      | Queued
      | Provisioning
      | Inactive
      | Powering_off
      | Powering_on

    let to_string = function
      | Active -> "active"
      | Queued -> "queued"
      | Provisioning -> "provisioning"
      | Inactive -> "inactive"
      | Powering_off -> "powering_off"
      | Powering_on -> "powering_on"

    let of_string = function
      | "active" -> Active
      | "queued" -> Queued
      | "provisioning" -> Provisioning
      | "inactive" -> Inactive
      | "powering_off" -> Powering_off
      | "powering_on" -> Powering_on
      | s -> raise (Unknown_value ("State.of_string", s))
  end

  module Event = struct
    type id = string

    let id_of_string id = id
    let id_to_string str = str

    type t = {
      id : id;
      state : State.t;
      event_type : string;
      body : string;
      created_at : Date.t;
    }

    let t_of_json json =
      {
        id = access "id" json |> Ezjsonm.get_string;
        state = access "state" json |> Ezjsonm.get_string |> State.of_string;
        event_type = access "type" json |> Ezjsonm.get_string;
        body = access "body" json |> Ezjsonm.get_string;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Event.t_of_json";
      }

    let to_string t =
      let created_at = Date.Printer.to_iso t.created_at in
      Format.sprintf
        "{\n\
         \tid: %s;\n\
         \tstate: %s;\n\
         \ttype: %s;\n\
         \tbody: %s;\n\
         \tcreated_at: %s;\n\
         }"
        (replace_empty t.id) (State.to_string t.state)
        (replace_empty t.event_type)
        (replace_empty t.body) created_at

    let pp t = Format.printf "%s\n" (to_string t)
  end

  module Device = struct
    type id = string

    let id_of_string id = id

    type action = Power_on | Power_off | Reboot | Reinstall | Rescue

    let action_to_string = function
      | Power_on -> "power_on"
      | Power_off -> "power_off"
      | Reboot -> "reboot"
      | Reinstall -> "reinstall"
      | Rescue -> "rescue"

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

    let os_of_string = function
      | "debian_9" -> Debian_9
      | "debian_10" -> Debian_10
      | "nixos_21_05" -> NixOs_21_05
      | "ubuntu_18_04" -> Ubuntu_18_04
      | "ubuntu_20_04" -> Ubuntu_20_04
      | "ubuntu_21_04" -> Ubuntu_21_04
      | "freebsd_11_2" -> FreeBSD_11_2
      | "centos_8" -> Centos_8
      | "alpine_3" -> Alpine_3
      | s -> raise (Unknown_value ("Device.os_of_string", s))

    let os_to_string = function
      | Debian_9 -> "debian_9"
      | Debian_10 -> "debian_10"
      | NixOs_21_05 -> "nixos_21_05"
      | Ubuntu_18_04 -> "ubuntu_18_04"
      | Ubuntu_20_04 -> "ubuntu_20_04"
      | Ubuntu_21_04 -> "ubuntu_21_04"
      | FreeBSD_11_2 -> "freebsd_11_2"
      | Centos_8 -> "centos_8"
      | Alpine_3 -> "alpine_3"

    type location =
      | Washington
      | Dallas
      | Silicon_valley
      | Sao_paulo
      | Amsterdam
      | Frankfurt
      | Singapore
      | Sydney

    let location_to_string = function
      | Washington -> "DC"
      | Dallas -> "DA"
      | Silicon_valley -> "SV"
      | Sao_paulo -> "SP"
      | Amsterdam -> "AM"
      | Frankfurt -> "FR"
      | Singapore -> "SG"
      | Sydney -> "SY"

    let location_of_string = function
      | "DC" -> Washington
      | "DA" -> Dallas
      | "SV" -> Silicon_valley
      | "SP" -> Sao_paulo
      | "AM" -> Amsterdam
      | "FR" -> Frankfurt
      | "SG" -> Singapore
      | "SY" -> Sydney
      | s -> raise (Unknown_value ("Device.location_of_string", s))

    type plan = C3_small_x86 | C3_medium_x86

    let plan_of_string = function
      | "c3.small.x86" -> C3_small_x86
      | "c3.medium.x86" -> C3_medium_x86
      | s -> raise (Unknown_value ("Device.plan_of_string", s))

    let plan_to_string = function
      | C3_small_x86 -> "c3.small.x86"
      | C3_medium_x86 -> "c3.medium.x86"

    type builder = {
      hostname : string option;
      tags : string list option;
      plan : plan;
      os : os;
      location : location;
    }

    let build ?hostname ?tags ~plan ~os ~location () =
      { hostname; tags; plan; os; location }

    let opt_to_list :
          'a.
          string ->
          ('a -> Ezjsonm.value) ->
          'a option ->
          (string * Ezjsonm.value) list =
     fun name fn v ->
      match v with Some value -> [ (name, fn value) ] | None -> []

    let builder_to_json builder =
      `O
        ([
           ("metro", `String (location_to_string builder.location));
           ("plan", `String (plan_to_string builder.plan));
           ("operating_system", `String (os_to_string builder.os));
         ]
        @ opt_to_list "hostname" Ezjsonm.string builder.hostname
        @ opt_to_list "tags"
            (fun tags -> `A (List.map Ezjsonm.string tags))
            builder.tags)

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

    let config_of_json json =
      let ips =
        try access "ip_addresses" json |> Ezjsonm.get_list Ip.config_of_json
        with _ -> []
      in
      {
        id = access "id" json |> Ezjsonm.get_string;
        hostname = access "hostname" json |> Ezjsonm.get_string;
        location =
          access "metro" json
          |> access "code"
          |> Ezjsonm.get_string
          |> String.uppercase_ascii
          |> location_of_string;
        plan =
          access "plan" json
          |> access "slug"
          |> Ezjsonm.get_string
          |> plan_of_string;
        os =
          access "operating_system" json
          |> access "slug"
          |> Ezjsonm.get_string
          |> os_of_string;
        state = access "state" json |> Ezjsonm.get_string |> State.of_string;
        tags = access "tags" json |> Ezjsonm.get_list Ezjsonm.get_string;
        user = access "user" json |> Ezjsonm.get_string;
        created_at =
          access "created_at" json
          |> Ezjsonm.get_string
          |> get_date ~name:"Device.config_of_json";
        ips;
      }

    let to_string config =
      let location = location_to_string config.location in
      let plan = plan_to_string config.plan in
      let state = State.to_string config.state in
      let tags = String.concat ", " config.tags in
      let created_at = Date.Printer.to_iso config.created_at in
      let ips =
        if config.ips = [] then "<empty>"
        else
          List.map (fun ip -> Ip.to_string ip) config.ips |> String.concat ", "
      in
      Format.sprintf
        "{\n\
         \tid: %s;\n\
         \thostname: %s;\n\
         \tlocation: %s;\n\
         \tplan: %s;\n\
         \tstate: %s;\n\
         \ttags:%s ;\n\
         \tuser: %s;\n\
         \tcreated_at: %s;\n\
         \tip: %s;\n\
         } " (replace_empty config.id)
        (replace_empty config.hostname)
        location plan state tags
        (replace_empty config.user)
        created_at ips

    let get_from t ~id =
      let path = Filename.concat "devices" id in
      let* json = Http.get ~t ~path in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Devices.get_from" ~err ~json v

    let get_events_from t ~id =
      let path = Format.sprintf "devices/%s/events" id in
      let* json = Http.get ~t ~path in
      try access "events" json |> Ezjsonm.get_list Event.t_of_json |> return
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Device.get_events_from" ~err ~json v

    let execute_action_on t ~id ~action =
      let action = action_to_string action in
      let path = Format.sprintf "devices/%s/actions?type=%s" id action in
      let* _json = Http.post_empty ~t ~path in
      return ()

    let delete t ~id ?(force = false) () =
      let path = Filename.concat "devices" id in
      let path = if force then path ^ "?force_delete=true" else path in
      let* _json = Http.delete ~t ~path in
      return ()

    let get_all_from_project t ~id =
      let path = Format.sprintf "projects/%s/devices" id in
      let* json = Http.get ~t ~path in
      try access "devices" json |> Ezjsonm.get_list config_of_json |> return
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Devices.get_all_from_project" ~err ~json v

    let create t ~id builder =
      let path = Format.sprintf "projects/%s/devices" id in
      let json = builder_to_json builder in
      let* json = Http.post ~t ~path json in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Device.create" ~err ~json v

    let update t ~id ?hostname ?tags () =
      let path = Format.sprintf "devices/%s" id in
      let fields =
        opt_to_list "hostname" Ezjsonm.string hostname
        @ opt_to_list "tags"
            (fun tags -> `A (List.map Ezjsonm.string tags))
            tags
      in
      let json = `O fields in
      let* json = Http.put ~t ~path json in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        fail_with_parsing ~name:"Device.update" ~err ~json v

    let pp config = Format.printf "%s\n" (to_string config)
  end
end
