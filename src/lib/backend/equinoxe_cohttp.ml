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

module Backend = struct
  type 'a io = 'a Lwt.t

  let return = Lwt.return
  let map = Lwt.map
  let bind f m = Lwt.bind m f
  let fail (`Msg e) = Lwt.fail_with e

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

  let get_body (resp, body) =
    let code = Cohttp.(Response.status resp |> Code.code_of_status) in
    if code >= 200 && code < 300 then Cohttp_lwt.Body.to_string body
    else
      let msg = Format.sprintf "Cohttp exits with HTTP code %d" code in
      Lwt.fail_with msg

  (**** Http methods ****)

  let compute ~f = compute ~time:10.0 ~f >>= get_body

  let get ~headers ~url =
    let headers = Cohttp.Header.of_list headers in
    let url = Uri.of_string url in
    let f () = Client.get ~headers url in
    compute ~f

  let post ~headers ~url body =
    let headers = Cohttp.Header.of_list headers in
    let url = Uri.of_string url in
    let body = Cohttp_lwt.Body.of_string body in
    let f () = Client.post ~headers ~body url in
    compute ~f

  let put ~headers ~url body =
    let headers = Cohttp.Header.of_list headers in
    let url = Uri.of_string url in
    let body = Cohttp_lwt.Body.of_string body in
    let f () = Client.put ~headers ~body url in
    compute ~f

  let delete ~headers ~url =
    let headers = Cohttp.Header.of_list headers in
    let url = Uri.of_string url in
    let f () = Client.delete ~headers url in
    compute ~f
end

module Api = Equinoxe.Make (Backend)
module Friendly_api = Equinoxe.MakeFriendly (Backend)
