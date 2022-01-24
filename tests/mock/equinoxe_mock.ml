let address = "https://equinix.mock/metal/"
let token = "mock token"

type query =
  | Get of string
  | Post of string * string
  | Put of string * string
  | Delete of string

exception Wrong_url of string
exception Wrong_token of string

module Http_mock (M : sig
  val expect : (query * string) list
end) =
struct
  type 'a io = 'a

  let return x = x
  let bind f x = f x
  let map f x = f x
  let fail (`Msg m) = failwith m

  module Mocks = Map.Make (struct
    type t = query

    let compare = Stdlib.compare
  end)

  let mocks = Mocks.of_seq @@ List.to_seq @@ M.expect

  let check_headers headers =
    assert (List.assoc "Content-Type" headers = "application/json");
    let token' = List.assoc "X-Auth-Token" headers in
    if token' <> token then raise (Wrong_token token')

  let address_length = String.length address

  let check_url url =
    if String.starts_with ~prefix:address url then
      String.sub url address_length (String.length url - address_length)
    else raise (Wrong_url url)

  let find key = Mocks.find key mocks

  let compute ~headers ~url fn =
    check_headers headers;
    let url = check_url url in
    find (fn ~url)

  let get = compute (fun ~url -> Get url)
  let delete = compute (fun ~url -> Delete url)

  let post ~headers ~url body =
    compute ~headers ~url (fun ~url -> Post (url, body))

  let put ~headers ~url body =
    compute ~headers ~url (fun ~url -> Post (url, body))
end

module type MOCK_API = Equinoxe.API with type 'a io = 'a

let mock expect =
  let module H = Http_mock (struct
    let expect = expect
  end) in
  (module Equinoxe.Make (H) : MOCK_API)

let test_wrong_address =
  Alcotest.test_case "Auth.get_user_api_keys: wrong address" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "") ]) in
  let wrong_address = "https://unexpected.com" in
  let t = E.create ~address:wrong_address ~token () in
  try
    let _ = E.Auth.get_user_api_keys t in
    Alcotest.fail "wrong address was not detected as invalid"
  with Wrong_url wrong_address' ->
    let wrong_address' =
      String.sub wrong_address' 0 (String.length wrong_address)
    in
    Alcotest.(check string) "wrong address" wrong_address wrong_address'

let test_wrong_token =
  Alcotest.test_case "Auth.get_user_api_keys: wrong token" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "") ]) in
  let wrong_token = "wrong token" in
  let t = E.create ~address ~token:wrong_token () in
  try
    let _ = E.Auth.get_user_api_keys t in
    Alcotest.fail "wrong token was not detected as invalid"
  with Wrong_token wrong_token' ->
    Alcotest.(check string) "wrong token" wrong_token wrong_token'

let test_expected_error =
  Alcotest.test_case "Auth.get_user_api_keys: expected error" `Quick
  @@ fun () ->
  let module E =
  (val mock [ (Get "user/api-keys", "{\"error\": \"expected!\"}") ])
  in
  let t = E.create ~address ~token () in
  try
    let _ = E.Auth.get_user_api_keys t in
    Alcotest.fail "expected error was not detected"
  with Failure msg ->
    let expected_msg = "The API returns the following error: \"expected!\"" in
    Alcotest.(check string) "expected error" expected_msg msg

let test_invalid_json =
  Alcotest.test_case "Auth.get_user_api_keys: invalid json" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "{\"parse error!") ]) in
  let t = E.create ~address ~token () in
  try
    let _ = E.Auth.get_user_api_keys t in
    Alcotest.fail "invalid json was not detected"
  with Failure msg ->
    let expected_msg = "JSON.of_buffer unclosed string" in
    Alcotest.(check string) "expected error" expected_msg msg

let test_errors =
  [
    ( "errors",
      [
        test_wrong_address;
        test_wrong_token;
        test_expected_error;
        test_invalid_json;
      ] );
  ]

module Json_test = struct
  type t = Ezjsonm.value

  let pp h t = Format.fprintf h "%s" (Ezjsonm.value_to_string t)
  let equal = Stdlib.( = )
end

let ezjsonm : Ezjsonm.value Alcotest.testable = (module Json_test)

let test_auth_get_user_api_keys =
  Alcotest.test_case "Auth.get_user_api_keys" `Quick @@ fun () ->
  let raw_json =
    {|{"api_keys":[
        {"id":"mock id",
         "token":"mock token",
         "created_at":"2022-01-05T12:34:56Z",
         "updated_at":"2022-02-07T14:41:27Z",
         "description":"mock descr",
         "user":{"href":"/metal/v1/users/1234-unique-id"},
         "read_only":false
        }]}|}
  in
  let _ = Ezjsonm.from_string raw_json in
  let module E = (val mock [ (Get "user/api-keys", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Auth.get_user_api_keys t in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_auth = [ ("auth", [ test_auth_get_user_api_keys ]) ]
let () = Alcotest.run "mock" (test_errors @ test_auth)
