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
module Json = Utils.Json
module Equinoxe = Utils.Equinoxe
open Cmdliner
open Utils.Term

(* Actions *)

let ips_id meth id =
  let address = Conf.address in
  let e = Equinoxe.create ~address () in
  match meth with
  | GET ->
      if has_requiered id then
        let id = Option.get id in
        Equinoxe.Ip.get_ips_id e ~id () |> Json.pp_r
      else not_all_requiered_r [ "id" ]
  | meth -> not_supported_r meth "/ips/{id}"

(* Terms *)
let ips_id_t =
  let doc = "Show information about a specific IP." in
  let exits = default_exits in
  let man =
    man_meth
      ~get:("Retrieve information about about an ip from its id", [ "id" ], [])
      ()
  in
  let id_t =
    let doc = "The ip id" in
    Arg.(value & opt (some string) None & info [ "id" ] ~doc)
  in
  Term.
    (term_result (const ips_id $ meth_t $ id_t), info "/ips/id" ~doc ~exits ~man)

let t = [ ips_id_t ]
