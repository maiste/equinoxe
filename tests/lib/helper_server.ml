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
module Json = Equinoxe.Json
open Piaf
open Lwt.Syntax
open Json.Infix

(* Many assert false as this is not supposed to test the web server but
   the API *)
let request_handler { Server.request; _ } =
  let* body = Body.to_string request.body in
  let body = match body with Ok b -> b | _ -> assert false in
  match request.meth with
  | `GET ->
      let body =
        Json.create () -+> ("id", ~$1.0) |> Json.export |> function
        | Ok body -> body
        | _ -> assert false
      in
      Lwt.wrap1 (Response.of_string ~body) `OK
  | `POST | `PUT ->
      let json = Json.of_string body in
      let userId =
        json --> "userId" |> Json.to_float_r |> function
        | Ok i -> i
        | _ -> assert false
      in
      let body =
        Json.create () -+> ("userId", ~$userId) |> Json.export |> function
        | Ok b -> b
        | _ -> assert false
      in
      Lwt.wrap1 (Response.of_string ~body) `OK
  | `DELETE -> Lwt.wrap1 (Response.of_string ~body:"{}") `OK
  | _ -> assert false

let connection_handler = Server.create request_handler

let listen port =
  let address = Unix.(ADDR_INET (inet_addr_loopback, port)) in
  Lwt_io.establish_server_with_client_socket address connection_handler

let close = Lwt_io.shutdown_server
