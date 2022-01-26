let address = "https://equinix.mock/metal/"
let token = "mock token"

type query =
  | Get of string
  | Post of string * string
  | Put of string * string
  | Delete of string
[@@deriving show]

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

  exception Mock_not_found of query

  let find key =
    try Mocks.find key mocks
    with Not_found ->
      failwith (Printf.sprintf "Not_found %s" (show_query key))

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

module type MOCK_FRIENDLY_API = Equinoxe.FRIENDLY_API with type 'a io = 'a

let mock_friendly expect =
  let module H = Http_mock (struct
    let expect = expect
  end) in
  (module Equinoxe.MakeFriendly (H) : MOCK_FRIENDLY_API)

module Json_test = struct
  type t = Ezjsonm.value

  let pp h t = Format.fprintf h "%s" (Ezjsonm.value_to_string t)
  let equal = Stdlib.( = )
end

let ezjsonm : Ezjsonm.value Alcotest.testable = (module Json_test)
