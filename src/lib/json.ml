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

type t = (Ezjsonm.value, [ `Msg of string ]) result

let error msg = Error (`Msg msg)

let ezjsonm_value_to_string = function
  | `Null -> "null"
  | `Bool b -> Format.sprintf "bool (%b)" b
  | `Float f -> Format.sprintf "float (%f)" f
  | `String s -> Format.sprintf "string (%s)" s
  | `A _ -> "json array"
  | `O _ -> "json object"

let conversion_error got expected =
  let error_msg =
    Format.sprintf "Conversion error: trying to convert %s into %s."
      (ezjsonm_value_to_string got)
      expected
  in
  error error_msg

let of_string content =
  try Ok (Ezjsonm.from_string content)
  with Ezjsonm.Parse_error (_, str_err) -> error str_err

let geto json name =
  Result.bind json (fun json ->
      match json with
      | `O fields -> (
          match List.assoc_opt name fields with
          | None ->
              let msg =
                Format.sprintf "JSON object doesn't contain the %s field" name
              in
              error msg
          | Some json -> Ok json)
      | _ ->
          let msg = "Trying to access a non object field in JSON." in
          error msg)

let geta json nth =
  Result.bind json (fun json ->
      match json with
      | `A items -> (
          match List.nth_opt items nth with
          | None ->
              let msg =
                Format.sprintf "JSON array doesn't contain the %d field." nth
              in
              error msg
          | Some item -> Ok item)
      | _ ->
          let msg = "Trying to access a non array field in JSON." in
          error msg)

let to_int_r json =
  Result.bind json (fun json ->
      match json with
      | `Float f ->
          if Float.is_integer f then Ok (int_of_float f)
          else conversion_error json "integer"
      | `String s -> (
          match int_of_string_opt s with
          | None -> conversion_error json "integer"
          | Some i -> Ok i)
      | _ -> conversion_error json "integer")

let to_string_r json =
  Result.bind json (fun json ->
      match json with `String s -> Ok s | _ -> conversion_error json "string")

module Infix = struct
  let ( --> ) json name = geto json name
  let ( |-> ) json nth = geta json nth
end
