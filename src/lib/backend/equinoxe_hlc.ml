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

type 'a io = ('a, [ `Msg of string ]) Lwt_result.t

module Client = Http_lwt_client

module Backend = struct
  type nonrec 'a io = 'a io

  let return = Lwt_result.return
  let map = Lwt_result.map
  let bind f m = Lwt_result.bind m f
  let fail e = Lwt_result.fail e

  (***** Helpers *****)

  let get_body = function
    | Ok (_, None) -> return ""
    | Ok (_, Some body) -> return body
    | Error e -> fail e

  let ( =<< ) f m = Lwt.bind m f

  (**** Http methods ****)

  let get ~headers ~url =
    get_body =<< Client.one_request ~meth:`GET ~headers url

  let post ~headers ~url body =
    get_body =<< Client.one_request ~meth:`POST ~headers ~body url

  let put ~headers ~url body =
    get_body =<< Client.one_request ~meth:`PUT ~headers ~body url

  let delete ~headers ~url =
    get_body =<< Client.one_request ~meth:`DELETE ~headers url
end

module Api = Equinoxe.Make (Backend)
