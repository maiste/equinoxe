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

module E = Equinoxe_cohttp.Api
module Json = E.Json
open Json
open Lwt.Syntax

let token = "YOUR TOKEN"
let api = E.create ~token ()

let get_project_id_from name =
  let* projects =
    E.Projects.get_projects api --> "projects"
    |> to_list (fun p ->
           let+ name = Lwt.return p --> "name" |> to_string
           and+ id = Lwt.return p --> "id" |> to_string in
           (name, id))
  in
  match List.find_opt (fun (name', _) -> name = name') projects with
  | Some (_, id) -> Lwt.return id
  | None -> Lwt.fail_with (Format.sprintf "get_project_id: %S not found" name)

let get_project_device_id project_id =
  E.Projects.get_projects_id_devices api ~id:project_id ()

let create_device project_id =
  let config =
    E.Devices.
      {
        hostname = "exp-1";
        location = Amsterdam;
        plan = C3_small_x86;
        os = Debian_10;
      }
  in
  E.Projects.post_projects_id_devices api ~id:project_id ~config () --> "id"
  |> Json.to_string

let wait_for_ready machine_id =
  let rec check () =
    let* state =
      E.Devices.get_devices_id api ~id:machine_id () --> "state"
      |> Json.to_string
    in
    match state with
    | "active" ->
        Format.printf "\nMachine is up!@.";
        Lwt.return state
    | state ->
        Format.printf "\rCheck status (%s) after sleeping 10 sec." state;
        Format.print_flush ();
        Unix.sleep 10;
        check ()
  in
  check ()

let get_ip machine_id =
  (E.Devices.get_devices_id api ~id:machine_id () --> "ip_addresses" |-> 0)
  --> "address"
  |> Json.to_string

let destroy_machine machine_id =
  E.Devices.delete_devices_id api ~id:machine_id () |> Json.to_unit

let deploy_wait_stop () =
  let* id = get_project_id_from "testing" in
  let* machine_id = create_device id in
  let () = Format.printf "Machine created.@." in
  let* _state = wait_for_ready machine_id in
  let* address = get_ip machine_id in
  let () = Format.printf "Ip is [%s]. Sleep for 60 sec.@." address in
  let () = Unix.sleep 60 in
  destroy_machine machine_id

let () =
  match Lwt_main.run (deploy_wait_stop ()) with
  | () -> Format.printf "Machine destroyed!@."
  | exception e -> Format.printf "Error with: %s@." (Printexc.to_string e)
