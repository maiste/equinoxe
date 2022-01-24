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
  type json = Ezjsonm.value
  type 'a io = 'a B.io

  let return x = B.return x
  let ( let* ) m f = B.bind f m
  let fail msg = B.fail (`Msg msg)

  type t = { address : string; token : string }

  let create ?(address = "https://api.equinix.com/metal/v1/") ?(token = "") () =
    { address; token }

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

    let run_with_body ~t ~path http_request json =
      let body = Ezjsonm.value_to_string json in
      let* body = request ~t ~path http_request body in
      get_json body

    let get = run B.get
    let post json = run_with_body B.post json
    let delete = run B.delete
  end

  module Auth = struct
    let get_user_api_keys t = Http.get ~t ~path:"user/api-keys"

    let post_user_api_keys t ?(read_only = true) ~description () =
      let json =
        `O
          [
            ("read_only", `Bool read_only); ("description", `String description);
          ]
      in
      Http.post ~t ~path:"user/api-keys" json

    let delete_user_api_keys_id t ~id () =
      let path = Filename.concat "user/api-keys/" id in
      Http.delete ~t ~path
  end

  module Devices = struct
    type action = Power_on | Power_off | Reboot | Reinstall | Rescue

    type os =
      | Debian_9
      | Debian_10
      | NixOs_21_05
      | Ubuntu_18_04
      | Ubuntu_20_04
      | Ubuntu_21_04
      | FreeBSD_11_2
      | Centos_8

    type location =
      | Washington
      | Dallas
      | Silicon_valley
      | Sao_paulo
      | Amsterdam
      | Frankfurt
      | Singapore
      | Sydney

    type plan = C3_small_x86 | C3_medium_x86

    type config = {
      hostname : string;
      location : location;
      plan : plan;
      os : os;
    }

    let os_to_string = function
      | Debian_9 -> "debian_9"
      | Debian_10 -> "debian_10"
      | NixOs_21_05 -> "nixos_21_05"
      | Ubuntu_18_04 -> "ubuntu_18_04"
      | Ubuntu_20_04 -> "ubuntu_20_04"
      | Ubuntu_21_04 -> "ubuntu_21_04"
      | FreeBSD_11_2 -> "freebsd_11_2"
      | Centos_8 -> "centos_8"

    let location_to_string = function
      | Washington -> "DC"
      | Dallas -> "DA"
      | Silicon_valley -> "SV"
      | Sao_paulo -> "SP"
      | Amsterdam -> "AM"
      | Frankfurt -> "FR"
      | Singapore -> "SG"
      | Sydney -> "SY"

    let plan_to_string = function
      | C3_small_x86 -> "c3.small.x86"
      | C3_medium_x86 -> "c3.medium.x86"

    let get_devices_id t ~id () =
      let path = Filename.concat "devices" id in
      Http.get ~t ~path

    let get_devices_id_events t ~id () =
      let path = Format.sprintf "devices/%s/events" id in
      Http.get ~t ~path

    let post_devices_id_actions t ~id ~action () =
      let action =
        match action with
        | Power_on -> "power_on"
        | Power_off -> "power_off"
        | Reboot -> "reboot"
        | Reinstall -> "reinstall"
        | Rescue -> "rescue"
      in
      let path = Format.sprintf "devices/%s/actions?type=%s" id action in
      let json = `O [] in
      Http.post ~t ~path json

    let delete_devices_id t ~id () =
      let path = Filename.concat "devices" id in
      Http.delete ~t ~path

    let get_devices_id_ips t ~id () =
      let path = Format.sprintf "devices/%s/ips" id in
      Http.get ~t ~path
  end

  module Projects = struct
    let get_projects t = Http.get ~t ~path:"projects"

    let get_projects_id t ~id () =
      let path = Filename.concat "projects" id in
      Http.get ~t ~path

    let get_projects_id_devices t ~id () =
      let path = Format.sprintf "projects/%s/devices" id in
      Http.get ~t ~path

    let post_projects_id_devices t ~id ~config () =
      let path = Format.sprintf "projects/%s/devices" id in
      let json =
        let open Devices in
        `O
          [
            ("metro", `String (location_to_string config.location));
            ("plan", `String (plan_to_string config.plan));
            ("operating_system", `String (os_to_string config.os));
            ("hostname", `String config.hostname);
          ]
      in
      Http.post ~t ~path json
  end

  module Ip = struct
    let get_ips_id t ~id () =
      let path = Filename.concat "ips" id in
      Http.get ~t ~path
  end
end

module MakeFriendly (B : Backend) : FRIENDLY_API with type 'a io = 'a B.io =
struct
  type 'a io = 'a B.io
  type t = { address : string; token : string }

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
           (json, Format.sprintf "access: field %s not found" field))

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

    let run_with_body ~t ~path http_request json =
      let body = Ezjsonm.value_to_string json in
      let* body = request ~t ~path http_request body in
      get_json body

    let get = run B.get
    let _post json = run_with_body B.post json
    let _delete = run B.delete
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
      let pp_empty s = if s = "" then "<empty>" else s in
      Format.sprintf
        "{\n\
         \tname: %s;\n\
         \tid: %s;\n\
         \taccount_id: %s;\n\
         \twebsite: %s;\n\
         \tmaintenance_email: %s;\n\
         \tmax_projects: %d;\n\
         }\n"
        (pp_empty config.id)
        (pp_empty config.account_id)
        (pp_empty config.name) (pp_empty config.website)
        (pp_empty config.maintenance_email)
        config.max_projects

    let get_from t id =
      let path = Filename.concat "organizations" id in
      let* json = Http.get ~t ~path in
      try
        let organization = config_of_json json in
        return organization
      with Ezjsonm.Parse_error (v, err) ->
        let msg =
          Format.sprintf "get: parse error %s with %s on %s" err
            (Ezjsonm.value_to_string v)
            (Ezjsonm.value_to_string json)
        in
        fail msg

    let get_all t =
      let* json = Http.get ~t ~path:"organizations" in
      try
        let organizations =
          access "organizations" json |> Ezjsonm.get_list config_of_json
        in
        return organizations
      with Ezjsonm.Parse_error (v, err) ->
        let msg =
          Format.sprintf "Orga.get_all: parse error %s on %s with %s " err
            (Ezjsonm.value_to_string v)
            (Ezjsonm.value_to_string json)
        in
        fail msg

    let pp config = Format.printf "%s" (to_string config)
  end

  module Users = struct
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
      try
        {
          id = access "id" json |> Ezjsonm.get_string;
          first_name = access "first_name" json |> Ezjsonm.get_string;
          last_name = access "last_name" json |> Ezjsonm.get_string;
          email = access "email" json |> Ezjsonm.get_string;
          created_at =
            access "create_at" json
            |> Ezjsonm.get_string
            |> Date.Parser.from_iso;
          last_login_at =
            access "last_login_at" json
            |> Ezjsonm.get_string
            |> Date.Parser.from_iso;
        }
      with Failure _ ->
        raise
          (Ezjsonm.Parse_error
             (json, Format.sprintf "Date.Parser.from_iso: can't parse date"))

    let to_string config =
      let replace_empty s = if s = "" then "<empty>" else s in
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
         }\n"
        (replace_empty config.id)
        (replace_empty config.first_name)
        (replace_empty config.last_name)
        (replace_empty config.email)
        created_at last_login_at

    let get_current_user t =
      let* json = Http.get ~t ~path:"user" in
      try return (config_of_json json)
      with Ezjsonm.Parse_error (v, err) ->
        let msg =
          Format.sprintf "User.get_current_user: parse error %s on %s with %s "
            err
            (Ezjsonm.value_to_string v)
            (Ezjsonm.value_to_string json)
        in
        fail msg

    let pp config = Format.printf "%s" (to_string config)
  end
end
