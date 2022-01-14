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

open Lwt.Syntax
open Lwt.Infix
module Client = Cohttp_lwt_unix.Client
module Json = Equinoxe.Json

module Backend = struct
  (**** Type definitions ****)

  type t = { address : string; token : string }

  let token t = t.token
  let address t = t.address

  (**** Default values ****)

  let build_header token =
    let token = if token = "" then [] else [ ("X-Auth-Token", token) ] in
    token @ [ ("Content-Type", "application/json") ] |> Cohttp.Header.of_list

  (***** Helpers *****)

  let compute ~time ~f =
    let* status =
      Lwt.pick
        [
          (f () >|= fun v -> `Done v);
          (Lwt_unix.sleep time >|= fun () -> `Timeout);
        ]
    in
    match status with
    | `Done v -> Lwt.return v
    | `Timeout -> Lwt.fail_with "Http request timeout"

  let convert_to_json (resp, body) =
    let code = Cohttp.(Response.status resp |> Code.code_of_status) in
    if code >= 200 && code < 300 then
      Lwt.catch
        (fun () ->
          let+ body = Cohttp_lwt.Body.to_string body in
          match body with "" -> Json.of_string "{ }" | s -> Json.of_string s)
        (fun e -> Lwt.return @@ Json.error (Printexc.to_string e))
    else
      let msg = Format.sprintf "Cohttp exits with HTTP code %d" code in
      Lwt.return @@ Json.error msg

  (**** Http methode ****)

  let compute = compute ~time:10.0

  let get_from t path =
    let headers = build_header t.token in
    let url = Filename.concat t.address path |> Uri.of_string in
    let f () = Client.get ~headers url in
    compute ~f

  let post_from t ~path body =
    let headers = build_header t.token in
    let url = Filename.concat t.address path |> Uri.of_string in
    let body = Cohttp_lwt.Body.of_string body in
    let f () = Client.post ~headers ~body url in
    compute ~f

  let put_from t ~path body =
    let headers = build_header t.token in
    let url = Filename.concat t.address path |> Uri.of_string in
    let body = Cohttp_lwt.Body.of_string body in
    let f () = Client.put ~headers ~body url in
    compute ~f

  let delete_from t path =
    let headers = build_header t.token in
    let url = Filename.concat t.address path |> Uri.of_string in
    let f () = Client.delete ~headers url in
    compute ~f

  (**** API ****)

  let create ~address ~token () = { address; token }

  let get t ~path () =
    let* resp = get_from t path in
    convert_to_json resp

  let post t ~path json =
    match Json.export json with
    | Ok body ->
        let* resp = post_from t ~path body in
        convert_to_json resp
    | Error (`Msg e) -> Lwt.return @@ Json.error e

  let put t ~path json =
    match Json.export json with
    | Ok body ->
        let* resp = put_from t ~path body in
        convert_to_json resp
    | Error (`Msg e) -> Lwt.return @@ Json.error e

  let delete t ~path () =
    let* resp = delete_from t path in
    convert_to_json resp

  let run json = Lwt_main.run json
end

module Api = Equinoxe.Make (Backend)
