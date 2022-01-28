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
module Equinoxe = Utils.Equinoxe_f
open Cmdliner
open Utils.Term
open Utils.Monad

(* Helpers *)

let config hostname location plan os =
  if
    has_requiered hostname
    && has_requiered location
    && has_requiered plan
    && has_requiered os
  then
    Some
      Equinoxe.Device.(
        build ~location:(Option.get location) ~plan:(Option.get plan)
          ~os:(Option.get os)
        |+ Hostname (Option.get hostname))
  else None

(* Actions *)

let projects token = function
  | GET ->
      let address = Conf.address in
      let e = Equinoxe.create ~address ~token () in
      let* projects = Equinoxe.Project.get_all e in
      List.iter Equinoxe.Project.pp projects;
      return ()
  | meth -> not_supported_r meth "/projects"

let projects_id token meth id =
  let address = Conf.address in
  let e = Equinoxe.create ~address ~token () in
  match meth with
  | GET ->
      if has_requiered id then (
        let id = Option.get id |> Equinoxe.Project.id_of_string in
        let* project = Equinoxe.Project.get_from e ~id in
        Equinoxe.Project.pp project;
        return ())
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/projects/{id}"

let projects_id_devices token meth id config =
  let address = Conf.address in
  let e = Equinoxe.create ~address ~token () in
  match meth with
  | GET ->
      if has_requiered id then (
        let id = Option.get id |> Equinoxe.Project.id_of_string in
        let* devices = Equinoxe.Device.get_all_from_project e ~id in
        List.iter (fun device -> Equinoxe.Device.pp device) devices;
        return ())
      else not_all_requiered_r [ "id" ]
  | POST ->
      if has_requiered id && has_requiered config then (
        let id = Option.get id |> Equinoxe.Project.id_of_string in
        let builder = Option.get config in
        let* device = Equinoxe.Device.create e ~id builder in
        Equinoxe.Device.pp device;
        return ())
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
  Term.
    ( lwt_result (const projects $ token_t $ meth_t),
      info "/projects" ~doc ~exits ~man )

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
    ( lwt_result (const projects_id $ token_t $ meth_t $ id_t),
      info "/projects/id" ~doc ~exits ~man )

let config_t =
  let hostname_t =
    let doc = "The name of the server" in
    Arg.(value & opt (some string) None & info [ "h"; "hostname" ] ~doc)
  in
  let plan_t =
    let doc = "The type of server needed" in
    let plan =
      Equinoxe.Device.(
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
      Equinoxe.Device.(
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
      Equinoxe.Device.(
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
    ( lwt_result (const projects_id_devices $ token_t $ meth_t $ id_t $ config_t),
      info "/projects/id/devices" ~doc ~exits ~man )

let t = [ projects_t; projects_id_t; projects_id_devices_t ]
