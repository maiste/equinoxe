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
  let module E = (val mock [ (Get "user/api-keys", raw_json) ]) in
  let t = E.create ~address ~token () in
  let json = E.Auth.get_user_api_keys t in
  let expected_json = Ezjsonm.from_string raw_json in
  Alcotest.(check ezjsonm) "json" expected_json json

let test_auth = [ ("auth", [ test_auth_get_user_api_keys ]) ]

module type MOCK_FRIENDLY_API = Equinoxe.FRIENDLY_API with type 'a io = 'a

let mock_friendly expect =
  let module H = Http_mock (struct
    let expect = expect
  end) in
  (module Equinoxe.MakeFriendly (H) : MOCK_FRIENDLY_API)

let test_orga_get_all =
  Alcotest.test_case "Orga.get_all" `Quick @@ fun () ->
  let raw_json =
    {|{
        "organizations": [
          {
            "id": "mock id 1",
            "name": "Mock Orga 1",
            "description": null,
            "website": "",
            "twitter": "",
            "created_at": "2021-12-20T10:47:12Z",
            "updated_at": "2022-01-19T08:52:08Z",
            "tax_id": null,
            "main_phone": null,
            "billing_phone": null,
            "credit_amount": 0,
            "personal": false,
            "customdata": {},
            "attn": null,
            "purchase_order": null,
            "billing_name": null,
            "enforce_2fa": false,
            "enforce_2fa_at": null,
            "short_id": "mock short id 1",
            "account_id": "mock account id 1",
            "enabled_features": [
              "maintenance_mail",
              "deploy_without_public_ip",
              "advanced_ips",
              "..."
            ],
            "maintenance_email": "admin@mock1.fr",
            "abuse_email": "admin@mock1.fr",
            "legal_company_name": "",
            "max_projects": 1,
            "default_collaborator_role": null,
            "address": {
              "href": "#mock-address-1"
            },
            "billing_address": {
              "href": "#mock-billing-1"
            },
            "account_manager": null,
            "logo": null,
            "logo_thumb": null,
            "projects": [
              {
                "href": "/metal/v1/projects/mock-projects-1"
              }
            ],
            "plan": "Starter",
            "monthly_spend": 9,
            "current_user_abilities": {
              "admin": true,
              "billing": true,
              "collaborator": true,
              "owner": false
            },
            "href": "/metal/v1/organizations/mock-href-1"
          },
          {
            "id": "mock id 2",
            "name": "Mock Orga 2",
            "description": null,
            "website": "mock2.com",
            "twitter": "",
            "created_at": "2018-01-16T09:39:51Z",
            "updated_at": "2022-01-22T11:53:40Z",
            "tax_id": "FR12345678901",
            "main_phone": null,
            "billing_phone": null,
            "credit_amount": 0,
            "personal": true,
            "customdata": {},
            "attn": null,
            "purchase_order": null,
            "billing_name": null,
            "enforce_2fa": false,
            "enforce_2fa_at": null,
            "short_id": "mock short id 2",
            "account_id": "mock account id 2",
            "enabled_features": [
              "maintenance_mail",
              "..."
            ],
            "maintenance_email": "maintenance@mock2.org",
            "abuse_email": "abuse@mock2.org",
            "legal_company_name": null,
            "max_projects": 200,
            "default_collaborator_role": null,
            "address": {
              "href": "#mock-address-2"
            },
            "billing_address": {
              "href": "#mock-billing-2"
            },
            "account_manager": {
              "href": "/metal/v1/users/mock-account-2"
            },
            "logo": "https://mock2.com/logo",
            "logo_thumb": "https://mock2.com/logo_thumb",
            "projects": [
              {
                "href": "/metal/v1/projects/mock-project-2"
              }
            ],
            "plan": "Public Cloud",
            "monthly_spend": 1234.438701629639,
            "current_user_abilities": {
              "admin": false,
              "billing": false,
              "collaborator": false,
              "owner": false
            },
            "href": "/metal/v1/organizations/mock-orga-2"
          }
        ],
        "meta": {
          "first": {
            "href": "/organizations?page=1"
          },
          "previous": null,
          "self": {
            "href": "/organizations?page=1"
          },
          "next": null,
          "last": {
            "href": "/organizations?page=1"
          },
          "current_page": 1,
          "last_page": 1,
          "total": 2
        }
      }
    |}
  in
  let module E = (val mock_friendly [ (Get "organizations", raw_json) ]) in
  let t = E.create ~address ~token () in
  let orgas = E.Orga.get_all t in
  let expected =
    let open E.Orga in
    [
      {
        id = id_of_string "mock id 1";
        name = "Mock Orga 1";
        account_id = "mock account id 1";
        website = "";
        maintenance_email = "admin@mock1.fr";
        max_projects = 1;
      };
      {
        id = id_of_string "mock id 2";
        name = "Mock Orga 2";
        account_id = "mock account id 2";
        website = "mock2.com";
        maintenance_email = "maintenance@mock2.org";
        max_projects = 200;
      };
    ]
  in
  List.iter2
    (fun expected orga ->
      let open E.Orga in
      Alcotest.(check string) "name" expected.name orga.name;
      Alcotest.(check string) "account id" expected.account_id orga.account_id;
      Alcotest.(check string) "website" expected.website orga.website;
      Alcotest.(check string)
        "maintenance email" expected.maintenance_email orga.maintenance_email;
      Alcotest.(check int)
        "max projects" expected.max_projects orga.max_projects;
      assert (expected.E.Orga.id = orga.E.Orga.id))
    expected orgas

let test_orga_get_from =
  Alcotest.test_case "Orga.get_from" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "mock-id-1",
        "name": "Mock Orga 1",
        "description": null,
        "website": "",
        "twitter": "",
        "created_at": "2021-12-20T10:47:12Z",
        "updated_at": "2022-01-19T08:52:08Z",
        "tax_id": null,
        "main_phone": null,
        "billing_phone": null,
        "credit_amount": 0,
        "personal": false,
        "customdata": {},
        "attn": null,
        "purchase_order": null,
        "billing_name": null,
        "enforce_2fa": false,
        "enforce_2fa_at": null,
        "short_id": "mock short id 1",
        "account_id": "mock account id 1",
        "enabled_features": [
          "maintenance_mail",
          "deploy_without_public_ip",
          "advanced_ips",
          "..."
        ],
        "maintenance_email": "admin@mock1.fr",
        "abuse_email": "admin@mock1.fr",
        "legal_company_name": "",
        "max_projects": 1,
        "default_collaborator_role": null,
        "address": {
          "href": "#mock-address-1"
        },
        "billing_address": {
          "href": "#mock-billing-1"
        },
        "account_manager": null,
        "logo": null,
        "logo_thumb": null,
        "projects": [
          {
            "href": "/metal/v1/projects/mock-projects-1"
          }
        ],
        "plan": "Starter",
        "monthly_spend": 9,
        "current_user_abilities": {
          "admin": true,
          "billing": true,
          "collaborator": true,
          "owner": false
        },
        "href": "/metal/v1/organizations/mock-href-1"
      }|}
  in
  let module E =
  (val mock_friendly [ (Get "organizations/mock-id-1", raw_json) ])
  in
  let t = E.create ~address ~token () in
  let requested_id = E.Orga.id_of_string "mock-id-1" in
  let orga = E.Orga.get_from t requested_id in
  let expected =
    E.Orga.
      {
        id = requested_id;
        name = "Mock Orga 1";
        account_id = "mock account id 1";
        website = "";
        maintenance_email = "admin@mock1.fr";
        max_projects = 1;
      }
  in
  let open E.Orga in
  Alcotest.(check string) "name" expected.name orga.name;
  Alcotest.(check string) "account id" expected.account_id orga.account_id;
  Alcotest.(check string) "website" expected.website orga.website;
  Alcotest.(check string)
    "maintenance email" expected.maintenance_email orga.maintenance_email;
  Alcotest.(check int) "max projects" expected.max_projects orga.max_projects;
  assert (expected.E.Orga.id = orga.E.Orga.id)

let test_orga = [ ("orga", [ test_orga_get_all; test_orga_get_from ]) ]
let () = Alcotest.run "mock" (test_errors @ test_auth @ test_orga)
