let address = "https://equinix.mock/metal/"
let token = "mock token"

let expected_headers =
  [ ("X-Auth-Token", token); ("Content-Type", "application/json") ]

module type MOCK_API = Equinoxe.API with type 'a io = 'a

let mock expect =
  let module H : Terminus.S with type 'a io = 'a =
  (val Terminus.Mock.mock ~address ~expected_headers ~expect ())
  in
  (module Equinoxe.Make (H) : MOCK_API)
