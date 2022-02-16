open Mock

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
  let module E = (val mock [ (Get "user/api-keys", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Auth in
  let keys = get_keys t in
  match keys with
  | [ single ] ->
      Alcotest.(check string) "token" single.token "mock token";
      Alcotest.(check bool) "read_only" single.read_only false;
      Alcotest.(check string) "description" single.description "mock descr";
      assert (single.id = id_of_string "mock id")
  | _ -> Alcotest.fail "expected one Auth.config"

let test_auth_post_user_api_keys =
  Alcotest.test_case "Auth.post_user_api_keys" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "token": "string",
        "created_at": "2019-08-24T14:15:22Z",
        "updated_at": "2019-08-24T14:15:22Z",
        "description": "Hello World!",
        "read_only": true,
        "user": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "short_id": "string",
          "first_name": "string",
          "last_name": "string",
          "full_name": "string",
          "email": "string",
          "avatar_url": "string",
          "avatar_thumb_url": "string",
          "two_factor_auth": "string",
          "max_projects": 0,
          "max_organizations": 0,
          "created_at": "2019-08-24T14:15:22Z",
          "updated_at": "2019-08-24T14:15:22Z",
          "timezone": "string",
          "fraud_score": "string",
          "last_login_at": "2019-08-24T14:15:22Z",
          "emails": [
            {
              "href": "string"
            }
          ],
          "href": "string",
          "phone_number": "string",
          "customdata": {}
        },
        "project": {
          "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
          "name": "string",
          "created_at": "2019-08-24T14:15:22Z",
          "updated_at": "2019-08-24T14:15:22Z",
          "max_devices": {},
          "members": [
            {
              "href": "string"
            }
          ],
          "memberships": [
            {
              "href": "string"
            }
          ],
          "network_status": {},
          "invitations": [
            {
              "href": "string"
            }
          ],
          "payment_method": {
            "href": "string"
          },
          "devices": [
            {
              "href": "string"
            }
          ],
          "ssh_keys": [
            {
              "href": "string"
            }
          ],
          "volumes": [
            {
              "href": "string"
            }
          ],
          "bgp_config": {
            "href": "string"
          },
          "customdata": {}
        }
      }|}
  in
  let expected_input = {|{"read_only":true,"description":"Hello World!"}|} in
  let module E =
  (val mock [ (Post ("user/api-keys", expected_input), raw_json) ])
  in
  let t = E.create ~address ~token () in
  let description = "Hello World!" in
  let open E.Auth in
  let config = create_key t ~description () in
  Alcotest.(check string) "token" config.token "string";
  Alcotest.(check bool) "read_only" config.read_only true;
  Alcotest.(check string) "description" config.description description;
  assert (config.id = id_of_string "497f6eca-6276-4993-bfeb-53cbbbba6f08")

let test_auth_delete_user_api_keys_id =
  Alcotest.test_case "Auth.delete_user_api_keys_id" `Quick @@ fun () ->
  let module E = (val mock [ (Delete "user/api-keys/id54321", "") ]) in
  let t = E.create ~address ~token () in
  E.Auth.delete_key t ~id:(E.Auth.id_of_string "id54321")

let tests =
  [
    test_auth_get_user_api_keys;
    test_auth_post_user_api_keys;
    test_auth_delete_user_api_keys_id;
  ]
