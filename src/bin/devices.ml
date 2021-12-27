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

module Conf = Utils.Conf
module Json = Utils.Json
module Equinoxe = Utils.Equinoxe
open Cmdliner
open Utils.Term

(* Actions *)

let devices_id meth id =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  match meth with
  | GET ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Devices.get_devices_id e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | DELETE ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Devices.delete_devices_id e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/devices/{id}"

let devices_id_actions meth id action =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  match meth with
  | POST ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Devices.post_devices_id_actions e ~id ~action () |> Json.pp_r
      else not_all_requiered_r [ "id"; "actions" ]
  | meth -> not_supported_r meth "/devices/{id}/actions"

let devices_id_events meth id =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  match meth with
  | GET ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Devices.get_devices_id_events e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/devices/{id}/events"

(* Terms *)

let devices_id_t =
  let doc = "Show the device, referenced by the id" in
  let exits = default_exits in
  let man =
    man_meth
      ~get:("Retrieve information about a specific device", [ "id" ], [])
      ()
  in
  let id_t =
    let doc = "The device id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    ( term_result (const devices_id $ meth_t $ id_t),
      info "/devices/id" ~doc ~exits ~man )

let devices_id_actions_t =
  let doc = "Execute an action on a specific device" in
  let exits = default_exits in
  let man =
    man_meth
      ~post:("Execute an action on a specific device", [ "id"; "action" ], [])
      ()
  in
  let id_t =
    let doc = "The device id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  let action_t =
    let doc =
      "The action to execute: power_on, power_off, reboot, reinstall, rescue"
    in
    let action =
      Arg.enum
        [
          ("power_on", Equinoxe.Devices.Power_on);
          ("power_off", Equinoxe.Devices.Power_off);
          ("reboot", Equinoxe.Devices.Reboot);
          ("reinstall", Equinoxe.Devices.Reinstall);
          ("rescue", Equinoxe.Devices.Rescue);
        ]
    in
    Arg.(required & opt (some action) None & info [ "a"; "actions" ] ~doc)
  in
  Term.
    ( term_result (const devices_id_actions $ meth_t $ id_t $ action_t),
      info "/devices/id/actions" ~doc ~exits ~man )

let devices_id_events_t =
  let doc = "Show events on a specific device" in
  let exits = default_exits in
  let man =
    man_meth ~get:("Retrieve events on a specific device", [ "id" ], []) ()
  in
  let id_t =
    let doc = "The device id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    ( term_result (const devices_id $ meth_t $ id_t),
      info "/devices/id/events" ~doc ~exits ~man )

let t = [ devices_id_t; devices_id_events_t; devices_id_actions_t ]
