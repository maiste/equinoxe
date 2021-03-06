open Mock

let test_get_user =
  Alcotest.test_case "Users.get_user" `Quick @@ fun () ->
  let raw_json =
    {|{
        "id": "497f6eca-6276-4993-bfeb-53cbbbba6f08",
        "short_id": "string",
        "first_name": "mock first",
        "last_name": "mock last",
        "full_name": "string",
        "email": "mock@mock.com",
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
      }|}
  in
  let module E = (val mock [ (Get "user", raw_json) ]) in
  let t = E.create ~address ~token () in
  let open E.User in
  let user = get_current_user t in
  Alcotest.(check string) "first_name" user.first_name "mock first";
  Alcotest.(check string) "last_name" user.last_name "mock last";
  Alcotest.(check string) "email" user.email "mock@mock.com"

let tests = [ test_get_user ]
