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

module E = Equinoxe_cohttp
open Lwt.Syntax

let token = "Your token"
let api = E.create ~token ()

let get_project_id_from name =
  let* projects = E.Project.get_all api in
  match
    List.find_opt (fun E.Project.{ name = name'; _ } -> name = name') projects
  with
  | Some project -> Lwt.return project.id
  | None -> Lwt.fail_with (Format.sprintf "get_project_id: %S not found" name)

let get_project_device_id project_id =
  E.Device.get_all_from_project api ~id:project_id

let create_device project_id =
  let open E.Device in
  let builder =
    build ~plan:C3_small_x86 ~location:Amsterdam ~os:Debian_10
    |+ Hostname "friendly-api-test"
  in
  let* config = create api ~id:project_id builder in
  Lwt.return config.id

let wait_for state machine_id =
  let rec check () =
    let* device = E.Device.get_from api ~id:machine_id in
    if device.state = state then Lwt.return ()
    else
      match device.state with
      | E.State.Active ->
          Format.printf "\nMachine is up!@.";
          check ()
      | s ->
          Format.printf "\rCheck status (%s) after sleeping 10 sec."
            (E.State.to_string s);
          Format.print_flush ();
          Unix.sleep 10;
          check ()
  in
  check ()

let get_ip machine_id =
  let* config = E.Device.get_from api ~id:machine_id in
  Lwt.return E.Device.(config.ips)

let destroy_machine machine_id = E.Device.delete api ~id:machine_id ()

let deploy_wait_stop () =
  let* id = get_project_id_from "testing" in
  let* machine_id = create_device id in
  Lwt.finalize
    (fun () ->
      let () = Format.printf "Machine created.@." in
      let* _state = wait_for E.State.Active machine_id in
      let* ips = get_ip machine_id in
      let () =
        match ips with
        | ip :: _ -> Format.printf "Ip is [%s]. Sleep for 60 sec.@." ip.address
        | _ -> Format.printf "IP not found.@."
      in
      let* () =
        Format.printf "Turn machine off@.";
        E.Device.execute_action_on api ~id:machine_id ~action:E.Device.Power_off
      in
      let* () = wait_for E.State.Inactive machine_id in
      let* () =
        Format.printf "Turn machine on.@.";
        E.Device.execute_action_on api ~id:machine_id ~action:E.Device.Power_on
      in
      let* () = wait_for E.State.Active machine_id in
      let* () =
        Format.printf "Reboot@.";
        E.Device.execute_action_on api ~id:machine_id ~action:E.Device.Reboot
      in
      let* () = wait_for E.State.Active machine_id in
      Lwt_unix.sleep 60.0)
    (fun () -> destroy_machine machine_id)

let () =
  match Lwt_main.run (deploy_wait_stop ()) with
  | () -> Format.printf "Machine destroyed!@."
  | exception e -> Format.printf "Error with: %s@." (Printexc.to_string e)
