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

module J = Ezjsonm

module MakeTest
    (Http : Equinoxe.Backend) (Config : sig
      val port : int
    end) =
struct
  let port = Config.port

  let headers =
    [ ("X-Auth-Token", "mytoken"); ("Content-Type", "application/json") ]

  let url = "http://localhost:" ^ string_of_int port

  let return x = Http.return x
  let ( let* ) m f = Http.bind f m

  let test_get _ () =
    let* json = Http.get ~url ~headers in
    let json = Ezjsonm.value_from_string json in
    let id = J.find json [ "id" ] |> J.get_int in
    Alcotest.(check int "gather id from get" id 1);
    return ()

  let test_post _ () =
    let body =
      `O
        [
          ("title", `String "foo");
          ("body", `String "bar");
          ("userId", `Float 1.0);
        ]
      |> J.value_to_string
    in
    let* json = Http.post ~url ~headers body in
    let json = Ezjsonm.value_from_string json in
    let id = J.find json [ "userId" ] |> J.get_int in
    Alcotest.(check int "gather id from post" id 1);
    return ()

  let test_put _ () =
    let body =
      `O
        [
          ("title", `String "foo");
          ("body", `String "bar");
          ("userId", `Float 1.0);
        ]
      |> J.value_to_string
    in
    let* json = Http.put ~url ~headers body in
    let json = Ezjsonm.value_from_string json in
    let id = J.find json [ "userId" ] |> J.get_int in
    Alcotest.(check int "gather userId from put" id 1);
    return ()

  let test_delete _ () =
    let* _ = Http.delete ~url ~headers in
    return ()

  (* Main *)

  let run ~exec name =
    let name = Format.sprintf "Http %s module" name in
    let quick name test =
      Alcotest.test_case name `Quick (fun x -> exec (test x))
    in
    Alcotest.(
      run name
        [
          ( "call",
            [
              quick "GET Method" test_get;
              quick "POST Method" test_post;
              quick "PUT Method" test_put;
              quick "DELETE Method" test_delete;
            ] );
        ])
end
