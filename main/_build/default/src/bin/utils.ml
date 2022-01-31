(*****************************************************************************)
(* Open Source License                                                       *)
(* Copyright (c) 2021-present Étienne Marais <etienne@maiste.fr>             *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR*)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL   *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER*)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING   *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER       *)
(* DEALINGS IN THE SOFTWARE.                                                 *)
(*                                                                           *)
(*****************************************************************************)

open Cmdliner

(* Import module and create Equinoxe from Ezcurl. *)
module Equinoxe = Equinoxe_hlc

module Monad = struct
  let ( let* ) m f = Equinoxe_hlc.Backend.bind f m
  let return = Equinoxe_hlc.Backend.return
end

module Conf = struct
  (* Constantes definitions. *)
  let name = "equinoxe-cli"
  let version = "0.1.0"
  let license = "MIT"
  let authors = [ "Etienne Marais <etienne@maiste.fr>" ]
  let description = "A CLI tool to call Equinix API in OCaml."
  let homepage = "https://github.com/maiste/equinoxe"
  let bug_reports = "https://github.com/maiste/equinoxe/issues"
  let dev_repo = "git://github.com/maiste/equinoxe.git"

  (* API constantes. *)
  let address = "https://api.equinix.com/metal/v1/"

  (* General man page. *)
  let manpage =
    let bug = [ `S Manpage.s_bugs; `P ("Report bugs: " ^ bug_reports) ] in
    let authors =
      List.fold_left
        (fun acc author -> acc @ [ `P author; `Noblank ])
        [ `S Manpage.s_authors ] authors
    in
    let contribution =
      [
        `S "CONTRIBUTION";
        `P ("$(b,License): " ^ license);
        `P ("$(b,Homepage): " ^ homepage);
        `P ("$(b,Dev repository): " ^ dev_repo);
      ]
    in
    bug @ contribution @ authors
end

module Term = struct
  type meth = GET | POST | DELETE | PUT

  let to_string = function
    | GET -> "GET"
    | POST -> "POST"
    | DELETE -> "DELETE"
    | PUT -> "PUT"

  let meth_t =
    let doc =
      "The HTTP method you want to use. If not provided, the default method is \
       GET."
    in
    let meth =
      Arg.enum
        [ ("get", GET); ("post", POST); ("delete", DELETE); ("put", PUT) ]
    in
    Arg.(value & opt meth GET & info [ "m"; "meth" ] ~doc)

  let token_t =
    let doc = "The Equinix token required to execute actions" in
    Arg.(required & opt (some string) None & info [ "t"; "token" ] ~doc)

  let has_requiered opts = Option.is_some opts

  let format_info (description, args, opt_args) =
    let arguments =
      match (args, opt_args) with
      | [], [] -> ""
      | args, [] -> "Argument(s): " ^ String.concat ", " args ^ "."
      | [], opt_args -> "Opt argument(s): " ^ String.concat ", " opt_args ^ "."
      | args, opt_args ->
          "Argument(s): "
          ^ String.concat ", " args
          ^ " - Opt argument(s): "
          ^ String.concat ", " opt_args
          ^ "."
    in
    description ^ ". " ^ arguments

  let man_meth ?(get = ("Not supported", [], []))
      ?(post = ("Not supported", [], [])) ?(delete = ("Not supported", [], []))
      ?(put = ("Not supported", [], [])) () =
    [
      `S Manpage.s_description;
      `P ("GET: " ^ format_info get);
      `P ("POST: " ^ format_info post);
      `P ("PUT: " ^ format_info put);
      `P ("DELETE: " ^ format_info delete);
    ]

  let default_exits =
    [
      Term.exit_info ~doc:"on option parsing and execution error." ~max:125 1;
      Term.exit_info ~doc:"on success." 0;
    ]

  let not_supported_r meth case =
    Lwt_result.fail
      (`Msg
        (Format.sprintf "Method %s is not supported with %s." (to_string meth)
           case))

  let not_all_requiered_r opts =
    let header = "The following options are requiered but not provided:\n" in
    let opts =
      List.fold_left (fun acc opt -> "- " ^ opt ^ "\n" ^ acc) "" opts
    in
    let msg = header ^ opts in
    Lwt_result.fail (`Msg msg)

  let lwt_result t = Term.(term_result (const Lwt_main.run $ t))
end
