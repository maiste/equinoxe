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

let ( >>= ) = Result.bind
let ( >|= ) v f = Result.map f v

type t = (Ezjsonm.value, [ `Msg of string ]) result

let create ?(kind = `Obj) () =
  match kind with
  | `Str str -> Ok (`String str)
  | `Obj -> Ok (`O [])
  | `Arr -> Ok (`A [])

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
  json >>= function
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
      error msg

let geta json nth =
  json >>= function
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
      error msg

let geto_from_a json (k, v) : t =
  let is_obj_with_field = function
    | `O fields -> (
        match List.assoc_opt k fields with
        | Some (`String v') -> v' = v
        | _ -> false)
    | _ -> false
  in
  json >>= function
  | `A objs -> (
      try Ok (List.find is_obj_with_field objs)
      with Not_found ->
        let msg = "Can't find the field into the array." in
        error msg)
  | _ ->
      let msg = "Trying to access a non array field in JSON." in
      error msg

let to_int_r json =
  json >>= function
  | `Float f as json ->
      if Float.is_integer f then Ok (int_of_float f)
      else conversion_error json "integer"
  | `String s as json -> (
      match int_of_string_opt s with
      | None -> conversion_error json "integer"
      | Some i -> Ok i)
  | json -> conversion_error json "integer"

let to_string_r json =
  json >>= function `String s -> Ok s | json -> conversion_error json "string"

let to_unit_r json = json >>= function _ -> Ok ()

let pp_r json =
  json >|= fun json ->
  Ezjsonm.value_to_string ~minify:false json |> Format.printf "%s"

let addo t (k, v) =
  v >>= fun v ->
  t >>= function
  | `O assoc -> Ok (`O ((k, v) :: assoc))
  | _ ->
      let msg =
        Format.sprintf
          "Trying to add key-value to a non-object json for key %s.)" k
      in
      error msg

let adda t v =
  v >>= fun v ->
  t >>= function
  | `A arr -> Ok (`A (v :: arr))
  | _ ->
      let msg = Format.sprintf "Trying to add a value to a non-array json." in
      error msg

let export json = json >|= fun json -> Ezjsonm.value_to_string json

module Infix = struct
  let ( ~+ ) v = create ~kind:(`Str v) ()
  let ( --> ) json name = geto json name
  let ( |-> ) json nth = geta json nth
  let ( |->? ) json kv = geto_from_a json kv
  let ( -+> ) json kv = addo json kv
  let ( |+> ) json kv = adda json kv
end

module Private = struct
  let filter_error json =
    json >>= function
    | `O fields as json -> (
        List.assoc_opt "errors" fields |> function
        | Some (`A [ `String s ]) ->
            let msg =
              Format.sprintf "The API returns the following error \"%s\"." s
            in
            error msg
        | _ -> Ok json)
    | json -> Ok json
end
