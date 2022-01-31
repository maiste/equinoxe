open Dune_lang.Decoder

(* Can be extended later if needed *)
type t =
  | Disabled
  | Enabled

let to_string = function
  | Disabled -> "disabled"
  | Enabled -> "enabled"

let to_dyn conf = to_string conf |> Dyn.Encoder.string

let encode t = Dune_lang.Encoder.string (to_string t)

let decoder = enum [ ("disabled", Disabled); ("enabled", Enabled) ]

let field ~since =
  field_o "subst" (Dune_lang.Syntax.since Stanza.syntax since >>> decoder)

let of_config = function
  | None -> Enabled
  | Some conf -> conf
