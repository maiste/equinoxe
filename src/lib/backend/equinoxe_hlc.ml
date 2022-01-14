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
module Json = Equinoxe.Json
module Client = Http_lwt_client

module Backend = struct

  type 'a io = 'a Lwt.t

  (***** Helpers *****)

  let convert_to_json resp =
    match resp with
    | Ok (_, Some "") -> Lwt.return (`O [])
    | Ok (_, Some s) -> Lwt.return (Ezjsonm.from_string s)
    | Ok (_, None) -> Lwt.fail_with "?"
    | Error (`Msg e) -> Lwt.fail_with e

  (**** Http methode ****)

  let get_from ~headers ~url =
    Client.one_request ~meth:`GET ~headers url

  let post_from ~headers ~url body =
    Client.one_request ~meth:`POST ~headers ~body url

  let put_from ~headers ~url body =
    Client.one_request ~meth:`PUT ~headers ~body url

  let delete_from ~headers ~url =
    Client.one_request ~meth:`DELETE ~headers url

  (**** API ****)

  let get ~headers ~url =
    let* resp = get_from ~headers ~url in
    convert_to_json resp

  let post ~headers ~url json =
    let body = Ezjsonm.value_to_string json in
    let* resp = post_from ~headers ~url body in
    convert_to_json resp

  let put ~headers ~url json =
    let body = Ezjsonm.value_to_string json in
    let* resp = put_from ~headers ~url body in
    convert_to_json resp

  let delete ~headers ~url =
    let* resp = delete_from ~headers ~url in
    convert_to_json resp
end

module Api = Equinoxe.Make (Backend)
