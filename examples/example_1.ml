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

module Json = Equinoxe.Json
module E = Equinoxe_cohttp.Api
open Json.Infix

let ( let* ) = Result.bind
let api = E.create ()

let get_project_id_from name =
  (E.Projects.get_projects api --> "projects" |->? ("name", name)) --> "id"
  |> Json.to_string_r

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
  |> Json.to_string_r

let wait_for_ready machine_id =
  let rec check () =
    let state =
      E.Devices.get_devices_id api ~id:machine_id () --> "state"
      |> Json.to_string_r
    in
    match state with
    | Ok "active" ->
        Format.printf "\nMachine is up!@.";
        state
    | Ok state ->
        Format.printf "\rCheck status (%s) after sleeping 10 sec." state;
        Format.print_flush ();
        Unix.sleep 10;
        check ()
    | _ -> state
  in
  check ()

let get_ip machine_id =
  (E.Devices.get_devices_id api ~id:machine_id () --> "ip_addresses" |-> 0)
  --> "address"
  |> Json.to_string_r

let destroy_machine machine_id =
  E.Devices.delete_devices_id api ~id:machine_id () |> Json.to_unit_r

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
  deploy_wait_stop () |> function
  | Ok () -> Format.printf "Machine destroyed!@."
  | Error (`Msg msg) -> Format.printf "Error with: %s@." msg
