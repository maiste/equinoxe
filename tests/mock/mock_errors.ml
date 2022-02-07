open Mock

let test_wrong_address =
  Alcotest.test_case "Auth.get_keys: wrong address" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "") ]) in
  let wrong_address = "https://unexpected.com" in
  let t = E.create ~address:wrong_address ~token () in
  try
    let _ = E.Auth.get_keys t in
    Alcotest.fail "wrong address was not detected as invalid"
  with Wrong_url wrong_address' ->
    let wrong_address' =
      String.sub wrong_address' 0 (String.length wrong_address)
    in
    Alcotest.(check string) "wrong address" wrong_address wrong_address'

let test_wrong_token =
  Alcotest.test_case "Auth.get_keys: wrong token" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "") ]) in
  let wrong_token = "wrong token" in
  let t = E.create ~address ~token:wrong_token () in
  try
    let _ = E.Auth.get_keys t in
    Alcotest.fail "wrong token was not detected as invalid"
  with Wrong_token wrong_token' ->
    Alcotest.(check string) "wrong token" wrong_token wrong_token'

let test_expected_error =
  Alcotest.test_case "Auth.get_keys: expected error" `Quick @@ fun () ->
  let module E =
  (val mock [ (Get "user/api-keys", "{\"error\": \"expected!\"}") ])
  in
  let t = E.create ~address ~token () in
  try
    let _ = E.Auth.get_keys t in
    Alcotest.fail "expected error was not detected"
  with Failure msg ->
    let expected_msg = "The API returns the following error: \"expected!\"" in
    Alcotest.(check string) "expected error" expected_msg msg

let test_invalid_json =
  Alcotest.test_case "Auth.get_keys: invalid json" `Quick @@ fun () ->
  let module E = (val mock [ (Get "user/api-keys", "{\"parse error!") ]) in
  let t = E.create ~address ~token () in
  try
    let _ = E.Auth.get_keys t in
    Alcotest.fail "invalid json was not detected"
  with Failure msg ->
    let expected_msg = "JSON.of_buffer unclosed string" in
    Alcotest.(check string) "expected error" expected_msg msg

let tests =
  [
    test_wrong_address; test_wrong_token; test_expected_error; test_invalid_json;
  ]
