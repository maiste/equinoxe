open Mock

let test_get_projects =
  Alcotest.test_case "Project.get_all" `Quick @@ fun () ->
  let raw_json =
    {|{
        "projects": [
          {
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
        ],
        "meta": {
          "first": {
            "href": "string"
          },
          "previous": {
            "href": "string"
          },
          "self": {
            "href": "string"
          },
          "next": {
            "href": "string"
          },
          "last": {
            "href": "string"
          },
          "total": 0
        }
      }|}
  in
  let module E = (val mock [ (Get "projects", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Project in
  let projects = get_all t in
  match projects with
  | [ single ] -> Alcotest.(check string) "name" single.name "string"
  | _ -> Alcotest.fail "expected one project"

let test_get_projects_id =
  Alcotest.test_case "Project.get_from" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "name": "mock project",
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
      }|}
  in
  let module E = (val mock [ (Get "projects/p1", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.Project in
  let project = get_from t ~id:(id_of_string "p1") in
  Alcotest.(check string) "name" project.name "mock project"

let tests = [ test_get_projects; test_get_projects_id ]
