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

(* Actions *)

let show_own_id () =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Users.get_user e |> Json.pp_r

let show_api_keys () =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Auth.get_user_api_keys e |> Json.pp_r

let create_api_key write description =
  let read_only = not write in
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Auth.post_user_api_keys e ~read_only ~description () |> Json.pp_r

let del_api_key id =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Auth.del_user_api_keys_id e ~id ()
  |> Json.filter_error
  |> Json.to_unit_r
  |> function
  | Ok () ->
      Format.printf "Api key %s deleted.@." id;
      Ok ()
  | e -> e

(* Terms *)

let show_own_id_t =
  let doc = "Show the id of the user." in
  let exits = Term.default_exits in
  Term.
    ( term_result (const show_own_id $ const ()),
      info "user-show-own-id" ~doc ~exits )

let show_api_keys_t =
  let doc = "Show the api keys of the user." in
  let exits = Term.default_exits in
  Term.
    ( term_result (const show_api_keys $ const ()),
      info "user-show-api-keys" ~doc ~exits )

let create_api_key_t =
  let doc = "Create a new api key for the user." in
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
    ( term_result (const create_api_key $ write $ description),
      info "user-create-api-key" ~doc ~exits )

let del_api_key_t =
  let doc = "Delete a user api-key." in
  let exits = Term.default_exits in
  let key_id =
    let docv = "KEY-ID" in
    let doc =
      "The ID of the key. It can be obtained with user-show-api-keys."
    in
    Arg.(required & pos ~rev:true 0 (some string) None & info [] ~docv ~doc)
  in
  Term.
    ( term_result (const del_api_key $ key_id),
      info "user-del-api-key" ~doc ~exits )

let t = [ show_own_id_t; show_api_keys_t; create_api_key_t; del_api_key_t ]
