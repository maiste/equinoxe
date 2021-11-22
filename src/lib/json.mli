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

(** The [JSON] module provide helpers to manipulate JSON objects. *)

type t
(** Abstract type to represent JSON objects. *)

val of_string : string -> t
(** [of_string str] takes a string [str] representing a JSON and transform it
    into an {!t} object you can manipulate with this module. *)

val geto : t -> string -> t
(** [geto json field_name] returns the {!t} value associated to the field_name. *)

val ( --> ) : t -> string -> t
(** [json --> field] is an infix operator that executes {!geto}. *)

val geta : t -> int -> t
(** [geta json nth]. returns the {!t} value associated to the nth element in the
    json. *)

val ( |-> ) : t -> int -> t
(** [json |-> nth] is an infix operator that executes {!geta}. *)

val to_int_r : t -> (int, string) result
(** [to_int_r json] transforms the [json] object into an int result with a
    printable error in case of failure. *)

val to_string_r : t -> (string, string) result
(** [to_string json] transforms the [json] into a string result with a printable
    error in case of failure.*)
