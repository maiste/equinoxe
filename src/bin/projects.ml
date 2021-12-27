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

module Conf = Utils.Conf
module Json = Utils.Json
module Equinoxe = Utils.Equinoxe
open Cmdliner
open Utils.Term

(* Helpers *)

type config = Equinoxe.Devices.config

let config hostname location plan os =
  if
    has_requiered hostname
    && has_requiered location
    && has_requiered plan
    && has_requiered os
  then
    Some
      Equinoxe.Devices.
        {
          hostname = Option.get hostname;
          location = Option.get location;
          plan = Option.get plan;
          os = Option.get os;
        }
  else None

let create_devices e id config =
  if has_requiered id && has_requiered config then e
  else not_all_requiered_r [ "id"; "hostname"; "plan"; "facility"; "os" ]

(* Actions *)

let projects = function
  | GET ->
      let endpoint = Conf.endpoint in
      let e = Equinoxe.create ~endpoint () in
      Equinoxe.Projects.get_projects e |> Json.pp_r
  | meth -> not_supported_r meth "/projects"

let projects_id meth id =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  match meth with
  | GET ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Projects.get_projects_id e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/projects/{id}"

let projects_id_devices meth id config =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  match meth with
  | GET ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Projects.get_projects_id_devices e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | POST ->
      if has_requiered id && has_requiered config then
        let id = Option.get id in
        let config = Option.get config in
        Equinoxe.Projects.post_projects_id_devices e ~id ~config () |> Json.pp_r
      else not_all_requiered_r [ "id"; "hostname"; "plan"; "facility"; "os" ]
  | meth -> not_supported_r meth "/projects/{id}/devices"

(* Terms *)

let projects_t =
  let doc = "Show all the projects of the user." in
  let exits = default_exits in
  let man =
    man_meth
      ~get:("Retrieve information about projects related to the user", [], [])
      ()
  in
  Term.(term_result (const projects $ meth_t), info "/projects" ~doc ~exits ~man)

let projects_id_t =
  let doc = "Show the project of the user referenced by the id" in
  let exits = default_exits in
  let man =
    man_meth
      ~get:("Retrieve information about a specific project", [ "id" ], [])
      ()
  in
  let id_t =
    let doc = "The project id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    ( term_result (const projects_id $ meth_t $ id_t),
      info "/projects/id" ~doc ~exits ~man )

let config_t =
  let hostname_t =
    let doc = "The name of the server" in
    Arg.(value & opt (some string) None & info [ "h"; "hostname" ] ~doc)
  in
  let plan_t =
    let doc = "The type of server needed" in
    let plan =
      Equinoxe.Devices.(
        Arg.enum
          [
            (plan_to_string C3_small_x86, C3_small_x86);
            (plan_to_string C3_medium_x86, C3_medium_x86);
          ])
    in
    Arg.(value & opt (some plan) None & info [ "p"; "plan" ] ~doc)
  in
  let location_t =
    let doc = "The location where to run the server" in
    let location =
      Equinoxe.Devices.(
        Arg.enum
          [
            (location_to_string Washington, Washington);
            (location_to_string Dallas, Dallas);
            (location_to_string Silicon_valley, Silicon_valley);
            (location_to_string Sao_paulo, Sao_paulo);
            (location_to_string Amsterdam, Amsterdam);
            (location_to_string Frankfurt, Frankfurt);
            (location_to_string Singapore, Singapore);
            (location_to_string Sydney, Sydney);
          ])
    in
    Arg.(value & opt (some location) None & info [ "l"; "location" ] ~doc)
  in
  let os_t =
    let doc = "The operating system of the server" in
    let os =
      Equinoxe.Devices.(
        Arg.enum
          [
            (os_to_string Debian_9, Debian_9);
            (os_to_string Debian_10, Debian_10);
            (os_to_string NixOs_21_05, NixOs_21_05);
            (os_to_string Ubuntu_18_04, Ubuntu_18_04);
            (os_to_string Ubuntu_20_04, Ubuntu_20_04);
            (os_to_string Ubuntu_21_04, Ubuntu_21_04);
            (os_to_string FreeBSD_11_2, FreeBSD_11_2);
            (os_to_string Centos_8, Centos_8);
          ])
    in
    Arg.(value & opt (some os) None & info [ "o"; "os" ] ~doc)
  in
  Term.(const config $ hostname_t $ location_t $ plan_t $ os_t)

let projects_id_devices_t =
  let doc =
    "Show all devices on the project of the user referenced by the id"
  in
  let exits = default_exits in
  let man =
    man_meth
      ~get:
        ( "Retrieve information about about devices associated with a specific \
           project",
          [ "id" ],
          [] )
      ~post:
        ( "Create a new server on the distant infrastructure",
          [ "id"; "hostname"; "plan"; "facility"; "os" ],
          [] )
      ()
  in
  let id_t =
    let doc = "The project id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    ( term_result (const projects_id_devices $ meth_t $ id_t $ config_t),
      info "/projects/id/devices" ~doc ~exits ~man )

let t = [ projects_t; projects_id_t; projects_id_devices_t ]
