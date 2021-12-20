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
open Json.Infix

(* Actions *)

let show_user_id () =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Users.get_own_id e --> "id" |> Json.to_string_r |> function
  | Ok str ->
      Format.printf "> Id is %s@." str;
      Ok ()
  | Error e -> Error e

let show_user_api_keys () =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Users.get_api_keys e |> Json.pp_r

let create_user_api_key write description =
  let read_only = not write in
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Users.add_api_key e ~read_only description |> Json.pp_r

(* Terms *)

let user_id_t =
  let doc = "Show the id of the user." in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  Term.
    ( term_result (const show_user_id $ const ()),
      info "user-show-id" ~doc ~sdocs ~exits )

let user_api_keys_t =
  let doc = "Show the api keys of the user." in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  Term.
    ( term_result (const show_user_api_keys $ const ()),
      info "user-show-api-keys" ~doc ~sdocs ~exits )

let create_user_api_keys_t =
  let doc = "Create a new api key for the user." in
  let sdocs = Manpage.s_common_options in
  let exits = Term.default_exits in
  let write =
    let doc = "Grant the key with writing rights. Absent means false." in
    Arg.(value & flag & info [ "w"; "write" ] ~doc)
  in
  let description =
    let docv = "KEY-NAME" in
    let doc = "Name of the key to create." in
    Arg.(required & pos ~rev:true 0 (some string) None & info [] ~docv ~doc)
  in
  Term.
    ( term_result (const create_user_api_key $ write $ description),
      info "user-create-api-key" ~doc ~sdocs ~exits )

let t = [ user_id_t; user_api_keys_t; create_user_api_keys_t ]
