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

module type S = sig
  (** This module gathers all the methods you need to be able to execute HTTP
      requests to contact an API server. It must send application/json request. *)

  type t
  (** [t] contains the information about the token you are using to identify the
      client and the address of the server (URL). *)

  val token : t -> string
  (** [token t] returns the token associated with the data structure. *)

  val address : t -> string
  (** [address t] returns the address of the server. *)

  val create : address:string -> token:string -> unit -> t
  (** [create ~address ~token ()] builds the configuration you are going to use
      to execute the request. *)

  val get : t -> path:string -> unit -> Json.t Lwt.t
  (** [get t ~path ()] executes a request to the server as a [GET] call and,
      returns the result as {!Json.t}. *)

  val post : t -> path:string -> Json.t -> Json.t Lwt.t
  (** [post t  ~path json] executes a request to the server as a [POST] call
      using {!Json.t} to describe the request. It returns the result as
      {!Json.t}. *)

  val put : t -> path:string -> Json.t -> Json.t Lwt.t
  (** [put t ~path json] executes a request to the server as a [PUT] call using
      {!Json.t} to describe the request. It returns the result as {!Json.t}. *)

  val delete : t -> path:string -> unit -> Json.t Lwt.t
  (** [delete t ~path ()] executes a request to the server as a [DELETE] call
      and, returns the result as {!Json.t}. *)

  val run : Json.t Lwt.t -> Json.t
  (** [run json] unwraps the API request and gives a JSON. *)
end
