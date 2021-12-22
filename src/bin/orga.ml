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

let show_own_orgas () =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Orga.get_organizations e |> Json.pp_r

let show_specific_orga id =
  let endpoint = Conf.endpoint in
  let e = Equinoxe.create ~endpoint () in
  Equinoxe.Orga.get_organizations_id e ~id () |> Json.filter_error |> Json.pp_r

(* Terms *)

let show_own_orgas_t =
  let doc = "Show all the organizations of the user." in
  let exits = Term.default_exits in
  Term.
    ( term_result (const show_own_orgas $ const ()),
      info "orga-show-all" ~doc ~exits )

let show_specific_orga_t =
  let doc = "Show the organization of the user referenced by the id." in
  let exits = Term.default_exits in
  let id =
    let docv = "ID" in
    let doc = "The organization id" in
    Arg.(required & pos 0 (some string) None & info [] ~docv ~doc)
  in
  Term.
    ( term_result (const show_specific_orga $ id),
      info "orga-show-specific" ~doc ~exits )

let t = [ show_own_orgas_t; show_specific_orga_t ]
