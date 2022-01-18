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

type error = [ `Msg of string ]
type headers = (string * string) list

module type S = sig
  (** This module gathers all the methods you need to be able to execute HTTP
      requests to contact an API server. It must send application/json request. *)

  type 'a io
  (** The I/O monad used to execute HTTP request. *)

  val return : 'a -> 'a io
  val map : ('a -> 'b) -> 'a io -> 'b io
  val bind : ('a -> 'b io) -> 'a io -> 'b io
  val fail : error -> 'a io

  val get : headers:headers -> url:string -> string io
  (** [get ~headers ~url] executes a request to the server as a [GET] call and,
      returns the result as a {!string}. *)

  val post : headers:headers -> url:string -> string -> string io
  (** [post ~headers ~url body] executes a request to the server as a [POST]
      call using {!body} to describe the request. It returns the result as a
      {!string}. *)

  val put : headers:headers -> url:string -> string -> string io
  (** [put ~headers ~url body] executes a request to the server as a [PUT] call
      using {!body} to describe the request. It returns the result as a
      {!string}. *)

  val delete : headers:headers -> url:string -> string io
  (** [delete ~headers ~url] executes a request to the server as a [DELETE] call
      and returns the result as a {!string}. *)
end
