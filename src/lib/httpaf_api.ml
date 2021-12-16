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

open Utils
open Lwt.Syntax
module H = Http_lwt_client

type t = { endpoint : string; token : string }

let token t = t.token
let endpoint t = t.endpoint

let build_header token =
  [ ("X-Auth-Token", token); ("Content-Type", "application/json") ]

let equinoxe_default_path = Sys.path_from_home_dir ".config/equinoxe/"

let token_from_path token_path =
  match Reader.read_token_opt token_path with
  | None -> raise Not_found
  | Some token -> token

let default_token () =
  let token_path = Filename.concat equinoxe_default_path "token" in
  token_from_path token_path

let get_token = function
  | `Default -> default_token ()
  | `Path token_path -> token_from_path token_path
  | `Str token -> token

let create ~endpoint ?(token = `Default) () =
  let token = get_token token in
  { endpoint; token }

let get t ~path () =
  let headers = build_header t.token in
  let url = Filename.concat t.endpoint path in
  let* resp = H.one_request ~meth:`GET ~headers url in
  match resp with
  | Ok (_, Some body) -> Lwt.return @@ Json.of_string body
  | Ok (_, None) -> Lwt.return @@ Json.error "Can't parse the empty string"
  | Error (`Msg e) -> Lwt.return @@ Json.error e

let post _t ~path:_ _json = failwith "TODO"
let put _t ~path:_ _json = failwith "TODO"
let delete _t ~path:_ = failwith "TODO"
let run json = Lwt_main.run json
