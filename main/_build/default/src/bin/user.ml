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

module Conf = Utils.Conf
module Equinoxe = Utils.Equinoxe
open Cmdliner
open Utils.Term
open Utils.Monad

(* Actions *)

let user token = function
  | GET ->
      let address = Conf.address in
      let e = Equinoxe.create ~address ~token () in
      let* users = Equinoxe.User.get_current_user e in
      Equinoxe.User.pp users;
      return ()
  | meth -> not_supported_r meth "/user"

let user_api_keys token meth description write =
  let address = Conf.address in
  let e = Equinoxe.create ~address ~token () in
  match meth with
  | GET ->
      let* keys = Equinoxe.Auth.get_keys e in
      List.iter Equinoxe.Auth.pp keys;
      return ()
  | POST ->
      let read_only = not write in
      let has_requiered = has_requiered description in
      let description = Option.get description in
      if has_requiered then (
        let* req = Equinoxe.Auth.create_key e ~read_only ~description () in
        Equinoxe.Auth.pp req;
        return ())
      else not_all_requiered_r [ "description" ]
  | meth -> not_supported_r meth "/user/api-keys"

let user_api_keys_id token meth id =
  let address = Conf.address in
  let e = Equinoxe.create ~address ~token () in
  match meth with
  | DELETE ->
      if has_requiered id then
        let id = Option.get id |> Equinoxe.Auth.id_of_string in
        Equinoxe.Auth.delete_key e ~id
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/user/api-keys"

(* Terms *)

let user_t =
  let doc = " Manage user." in
  let exits = default_exits in
  let man =
    man_meth ~get:("Retrieve informations about the current user.", [], []) ()
  in
  Term.
    (lwt_result (const user $ token_t $ meth_t), info "/user" ~doc ~exits ~man)

let user_api_keys_t =
  let doc = "Manage user api-keys." in
  let man =
    man_meth
      ~get:("Retrieve the all the api keys", [], [])
      ~post:("Create a new api key", [ "description" ], [ "write" ])
      ()
  in
  let exits = default_exits in
  let write_t =
    let doc = "Grant the key with writing rights. Absent means false." in
    Arg.(value & flag & info [ "write" ] ~doc)
  in
  let description_t =
    let doc = "Name of the key to create." in
    Arg.(value & opt (some string) None & info [ "description" ] ~doc)
  in
  Term.
    ( lwt_result
        (const user_api_keys $ token_t $ meth_t $ description_t $ write_t),
      info "/user/api-keys" ~doc ~exits ~man )

let user_api_keys_id_t =
  let doc = "Manage user api-keys with an id." in
  let exits = default_exits in
  let man = man_meth ~delete:("Delete an api key", [ "id" ], []) () in
  let id_t =
    let doc = "The ID of the key. It can be obtained with GET /user/api-keys" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    ( lwt_result (const user_api_keys_id $ token_t $ meth_t $ id_t),
      info "/user/api-keys/id" ~doc ~exits ~man )

let t = [ user_t; user_api_keys_t; user_api_keys_id_t ]
