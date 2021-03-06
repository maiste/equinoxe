open Mock

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
  let module E = (val mock [ (Get "organizations", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Orga in
  let orgas = get_all t in
  let expected =
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
      Alcotest.(check string) "name" expected.name orga.name;
      Alcotest.(check string) "account id" expected.account_id orga.account_id;
      Alcotest.(check string) "website" expected.website orga.website;
      Alcotest.(check string)
        "maintenance email" expected.maintenance_email orga.maintenance_email;
      Alcotest.(check int)
        "max projects" expected.max_projects orga.max_projects;
      assert (expected.id = orga.id))
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
  let module E = (val mock [ (Get "organizations/mock-id-1", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Orga in
  let requested_id = id_of_string "mock-id-1" in
  let orga = get_from t requested_id in
  let expected =
    {
      id = requested_id;
      name = "Mock Orga 1";
      account_id = "mock account id 1";
      website = "";
      maintenance_email = "admin@mock1.fr";
      max_projects = 1;
    }
  in
  Alcotest.(check string) "name" expected.name orga.name;
  Alcotest.(check string) "account id" expected.account_id orga.account_id;
  Alcotest.(check string) "website" expected.website orga.website;
  Alcotest.(check string)
    "maintenance email" expected.maintenance_email orga.maintenance_email;
  Alcotest.(check int) "max projects" expected.max_projects orga.max_projects;
  assert (expected.id = orga.id)

let tests = [ test_orga_get_all; test_orga_get_from ]
