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

module Client = Cohttp_lwt_unix.Client

module Backend = struct
  type 'a io = 'a Lwt.t

  let return = Lwt.return
  let map = Lwt.map
  let bind f m = Lwt.bind m f
  let fail (`Msg e) = Lwt.fail_with e

  (***** Helper *****)

  let compute fn ~headers ~url =
    let headers = Cohttp.Header.of_list headers in
    let url = Uri.of_string url in
    Lwt.bind (fn ~headers ~url) (fun (_, body) ->
        Cohttp_lwt.Body.to_string body)

  (**** Http methods ****)

  let get ~headers ~url =
    compute ~headers ~url @@ fun ~headers ~url -> Client.get ~headers url

  let post ~headers ~url body =
    compute ~headers ~url @@ fun ~headers ~url ->
    let body = Cohttp_lwt.Body.of_string body in
    Client.post ~headers ~body url

  let put ~headers ~url body =
    compute ~headers ~url @@ fun ~headers ~url ->
    let body = Cohttp_lwt.Body.of_string body in
    Client.put ~headers ~body url

  let delete ~headers ~url =
    compute ~headers ~url @@ fun ~headers ~url -> Client.delete ~headers url
end

include Equinoxe.Make (Backend)
