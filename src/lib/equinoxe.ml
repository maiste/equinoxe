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

include Equinoxe_intf
module Json = Json
module Default_api = Piaf_api
open Json.Infix

(* Fonctor to build API using a specific call API system. *)
module Make (C : CallAPI.S) = struct
  type t = C.t

  let create ~endpoint ?token () = C.create ~endpoint ?token ()

  module Users = struct
    let get_current_user t =
      let path = "user" in
      C.get ~path t () |> C.run

    let get_user_api_keys t =
      let path = "user/api-keys" in
      C.get ~path t () |> C.run

    let add_user_api_key t ?(read_only = true) description =
      let read_only = ("read_only", ~+(string_of_bool read_only)) in
      let description = ("description", ~+description) in
      let json = Json.create () -+> read_only -+> description in
      let path = "user/api-keys" in
      C.post t ~path json |> C.run

    let del_user_api_key t key_id =
      let path = Filename.concat "user/api-keys/" key_id in
      C.delete t ~path () |> C.run
  end

  module Orga = struct end
  module Metal = struct end
end
