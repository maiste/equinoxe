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

module Json = Equinoxe.Json
open Json.Infix
open Lwt.Syntax
open Lwt.Infix
open Utils

module MakeTest
    (Http : Equinoxe.Backend) (Config : sig
      val port : int
    end) =
struct
  let port = Config.port
  let address = "http://localhost:" ^ string_of_int port
  let http = Http.create ~address ~token:"" ()

  let compute_or_fail ?(time = 5.0) ~f server =
    ( Lwt.pick
        [
          (f >|= fun v -> `Done v); (Lwt_unix.sleep time >|= fun () -> `Timeout);
        ]
    >|= fun v -> v )
    >>= function
    | `Done v -> Lwt.return v
    | `Timeout ->
        Server.close server >>= fun () -> Lwt.fail (Failure "Timeout!")

  let test_address _ () =
    let address' = Http.address http in
    Alcotest.(check string "same address" address address');
    Lwt.return_unit

  let test_token_empty _ () =
    let token = Http.token http in
    Alcotest.(check string "empty token" token "");
    Lwt.return_unit

  let test_get _ () =
    let* server = Server.listen port in
    let json = Http.get http ~path:"" () in
    let* json = compute_or_fail ~f:json server in
    let id = json --> "id" |> Json.to_int_r in
    Alcotest.(check (result int error_msg) "gather id from get" id (Ok 1));
    Server.close server

  let test_post _ () =
    let* server = Server.listen port in
    let body =
      Json.create ()
      -+> ("title", ~+"foo")
      -+> ("body", ~+"bar")
      -+> ("userId", ~$1.0)
    in
    let json = Http.post http ~path:"" body in
    let* json = compute_or_fail ~f:json server in
    let id = json --> "userId" |> Json.to_int_r in
    Alcotest.(check (result int error_msg) "gather id from post" id (Ok 1));
    Server.close server

  let test_put _ () =
    let* server = Server.listen port in
    let body =
      Json.create ()
      -+> ("title", ~+"foo")
      -+> ("body", ~+"bar")
      -+> ("userId", ~$1.0)
    in
    let json = Http.put http ~path:"" body in
    let* json = compute_or_fail ~f:json server in
    let id = json --> "userId" |> Json.to_int_r in
    Alcotest.(check (result int error_msg) "gather userId from put" id (Ok 1));
    Server.close server

  let test_delete _ () =
    let* server = Server.listen port in
    let json = Http.delete http ~path:"" () in
    let* json = compute_or_fail ~f:json server in
    let id = json |> Json.to_unit_r in
    Alcotest.(check (result unit error_msg) "delete a resource" id (Ok ()));
    Server.close server

  (* Main *)

  let run name =
    let name = Format.sprintf "Http %s module" name in
    Alcotest_lwt.(
      run name
        [
          ( "getters",
            [
              test_case "Get right address" `Quick test_address;
              test_case "Get right token" `Quick test_token_empty;
            ] );
          ( "call",
            [
              test_case "GET Method" `Quick test_get;
              test_case "POST Method" `Quick test_post;
              test_case "PUT Method" `Quick test_put;
              test_case "DELETE Method" `Quick test_delete;
            ] );
        ])
end
