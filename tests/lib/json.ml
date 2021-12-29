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

open Utils
module Json = Equinoxe.Json

(* Creation *)

let test_create_array () =
  let a = Json.create ~kind:`Arr () in
  let a_str = Json.export a in
  Alcotest.(check (result string error_msg) "create array" a_str (Ok "[]"))

let test_create_object () =
  let o = Json.create ~kind:`Obj () in
  let o_str = Json.export o in
  Alcotest.(check (result string error_msg) "create object" o_str (Ok "{}"));
  let o = Json.create () in
  let o_str = Json.export o in
  Alcotest.(check (result string error_msg) "create object" o_str (Ok "{}"))

let test_create_str () =
  let s = Json.create ~kind:(`Str "Hello") () in
  let s_str = Json.export s in
  Alcotest.(
    check (result string error_msg) "create string" s_str (Ok "\"Hello\""))

let test_create_float () =
  let s = Json.create ~kind:(`Float 1.0) () in
  let s_str = Json.export s in
  Alcotest.(check (result string error_msg) "create string" s_str (Ok "1"))

let test_create_error () =
  let e = Json.error "Nope!" in
  let e_str = Json.export e in
  Alcotest.(
    check (result string error_msg) "create error" e_str (Error (`Msg "Nope!")))

let test_of_string () =
  let str = "{\"k2\":\"bar\",\"k1\":\"foo\"}" in
  let j = Json.of_string str in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "add to an object" j_str
      (Ok "{\"k2\":\"bar\",\"k1\":\"foo\"}"))

(* Setters *)
let test_adda () =
  let j = Json.create ~kind:`Arr () in
  let s1 = Json.create ~kind:(`Str "foo") () in
  let s2 = Json.create ~kind:(`Str "bar") () in
  let j = Json.adda j s1 in
  let j = Json.adda j s2 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "add to an array" j_str
      (Ok "[\"bar\",\"foo\"]"))

let test_adda_infix () =
  let open Json.Infix in
  let s1 = Json.create ~kind:(`Str "foo") () in
  let s2 = Json.create ~kind:(`Str "bar") () in
  let j = Json.create ~kind:`Arr () |+> s1 |+> s2 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "add to an array" j_str
      (Ok "[\"bar\",\"foo\"]"))

let test_addo () =
  let j = Json.create () in
  let s1 = Json.create ~kind:(`Str "foo") () in
  let s2 = Json.create ~kind:(`Str "bar") () in
  let j = Json.addo j ("k1", s1) in
  let j = Json.addo j ("k2", s2) in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "add to an object" j_str
      (Ok "{\"k2\":\"bar\",\"k1\":\"foo\"}"))

let test_addo_infix () =
  let open Json.Infix in
  let s1 = Json.create ~kind:(`Str "foo") () in
  let s2 = Json.create ~kind:(`Str "bar") () in
  let j = Json.create () -+> ("k1", s1) -+> ("k2", s2) in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "add to an object" j_str
      (Ok "{\"k2\":\"bar\",\"k1\":\"foo\"}"))

(* Getters *)

let json_str =
  "{\"k2\":1,\"k1\":\"foo\",\"k3\":[1,2,\"k4\",{\"k5\":\"foo\",\"k6\":1}],\"k7\":{\"k8\":1}}"

let json = Json.of_string json_str

let test_json_fo_getter () =
  let j_str = Json.export json in
  Alcotest.(
    check (result string error_msg) "json integrity" j_str (Ok json_str))

let test_geto () =
  let j = Json.geto json "k2" in
  let j_str = Json.export j in
  Alcotest.(check (result string error_msg) "get an object" j_str (Ok "1"));
  let j = Json.geto json "k8" in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get an object not in the layer" j_str
      (Error (`Msg "JSON object doesn't contain the k8 field.")));
  let j = Json.geto json "k2" in
  let j = Json.geto j "k8" in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get a field not from an object" j_str
      (Error (`Msg "Trying to access a non object field in JSON.")))

let test_geto_infix () =
  let open Json.Infix in
  let j = json --> "k2" in
  let j_str = Json.export j in
  Alcotest.(check (result string error_msg) "get an object" j_str (Ok "1"));
  let j = json --> "k8" in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get an object not in the layer" j_str
      (Error (`Msg "JSON object doesn't contain the k8 field.")));
  let j = json --> "k2" --> "k8" in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get a field not from an object" j_str
      (Error (`Msg "Trying to access a non object field in JSON.")))

let test_geta () =
  let open Json.Infix in
  let j = json --> "k3" in
  let j = Json.geta j 0 in
  let j_str = Json.export j in
  Alcotest.(check (result string error_msg) "get in array" j_str (Ok "1"));
  let j = json --> "k3" in
  let j = Json.geta j 4 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get in array higher index" j_str
      (Error (`Msg "JSON array doesn't contain the 4 field.")));
  let j = Json.geta json 1 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get a nth not from array" j_str
      (Error (`Msg "Trying to access a non array field in JSON.")))

let test_geta_infix () =
  let open Json.Infix in
  let j = json --> "k3" |-> 0 in
  let j_str = Json.export j in
  Alcotest.(check (result string error_msg) "get in array" j_str (Ok "1"));
  let j = json --> "k3" |-> 4 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get in array higher index" j_str
      (Error (`Msg "JSON array doesn't contain the 4 field.")));
  let j = json |-> 1 in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get a nth not from array" j_str
      (Error (`Msg "Trying to access a non array field in JSON.")))

let test_geto_from_a () =
  let open Json.Infix in
  let j = json --> "k3" in
  let j = Json.geto_from_a j ("k5", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in array" j_str
      (Ok "{\"k5\":\"foo\",\"k6\":1}"));
  let j = json --> "k3" in
  let j = Json.geto_from_a j ("k4", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in arrayi not found" j_str
      (Error (`Msg "Can't find the field into the array.")));
  let j = json --> "k2" in
  let j = Json.geto_from_a j ("k4", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in array" j_str
      (Error (`Msg "Trying to access a non array field in JSON.")))

let test_geto_from_a_infix () =
  let open Json.Infix in
  let j = json --> "k3" |->? ("k5", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in array" j_str
      (Ok "{\"k5\":\"foo\",\"k6\":1}"));
  let j = json --> "k3" |->? ("k4", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in arrayi not found" j_str
      (Error (`Msg "Can't find the field into the array.")));
  let j = json --> "k2" |->? ("k4", "foo") in
  let j_str = Json.export j in
  Alcotest.(
    check (result string error_msg) "get object in array" j_str
      (Error (`Msg "Trying to access a non array field in JSON.")))

let test_to_int_r () =
  let open Json.Infix in
  let j = json --> "k2" in
  let i = Json.to_int_r j in
  Alcotest.(check (result int error_msg) "get an int" i (Ok 1));
  let j = json --> "k1" in
  let i = Json.to_int_r j in
  Alcotest.(
    check (result int error_msg) "get an int from string" i
      (Error
         (`Msg "Conversion error: trying to convert string (foo) into integer.")))

let test_to_string_r () =
  let open Json.Infix in
  let j = json --> "k1" in
  let s = Json.to_string_r j in
  Alcotest.(check (result string error_msg) "get a string" s (Ok "foo"));
  let j = json --> "k2" in
  let s = Json.to_string_r j in
  Alcotest.(
    check (result string error_msg) "get a string from int" s
      (Error
         (`Msg
           "Conversion error: trying to convert float (1.000000) into string.")))

let test_to_unit_r () =
  let open Json.Infix in
  let j = json --> "k1" in
  let u = Json.to_unit_r j in
  Alcotest.(check (result unit error_msg) "get a unit" u (Ok ()))

let test_pp_r () =
  let open Json.Infix in
  let j = json --> "k1" in
  let u = Json.pp_r j in
  Alcotest.(check (result unit error_msg) "get a unit with pp" u (Ok ()))

(* Main *)

let () =
  Alcotest.(
    run "JSON"
      [
        ( "creation",
          [
            test_case "Create array" `Quick test_create_array;
            test_case "Create object" `Quick test_create_object;
            test_case "Create string" `Quick test_create_str;
            test_case "Create float" `Quick test_create_float;
            test_case "Create error" `Quick test_create_error;
            test_case "Create from string" `Quick test_of_string;
          ] );
        ( "addition",
          [
            test_case "Add to an array" `Quick test_adda;
            test_case "Add to an array - Infix" `Quick test_adda_infix;
            test_case "Add to an object" `Quick test_addo;
            test_case "Add to an object - Infix" `Quick test_addo_infix;
          ] );
        ( "getters",
          [
            test_case "Verify object" `Quick test_json_fo_getter;
            test_case "Get object" `Quick test_geto;
            test_case "Get object - Infix" `Quick test_geto_infix;
            test_case "Get array" `Quick test_geta;
            test_case "Get array - Infix" `Quick test_geta_infix;
            test_case "Get object from array" `Quick test_geto_from_a;
            test_case "Get object from array - Infix" `Quick
              test_geto_from_a_infix;
            test_case "Get an int" `Quick test_to_int_r;
            test_case "Get a string" `Quick test_to_string_r;
            test_case "Get a unit" `Quick test_to_unit_r;
            test_case "Get a unit from pp" `Quick test_pp_r;
          ] );
      ])
