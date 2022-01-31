#!/usr/bin/env ocaml
#directory "pkg";;
#use "topkg.ml";;

let builder = `OCamlbuild_no_ocamlfind []

let pkg_after_4_03 () =
  Pkg.describe "uchar" ~builder [
    Pkg.lib "pkg/META.empty" ~dst:"META" ]

let pkg_before_4_03 () =
  Pkg.describe "uchar" ~builder [
    Pkg.lib "pkg/META";
    Pkg.lib ~exts:Exts.module_library "src/uchar";
    Pkg.doc "README.md";
    Pkg.doc "CHANGES.md"; ]

let is_before_4_03 () =
  try
    let config = OCaml_config.read ~ocamlc:(Pkg.find_ocamlc builder) in
    let version = List.assoc "version" config in
    let version = Scanf.sscanf version "%d.%d" (fun maj min -> (maj, min)) in
    version < (4, 03)
  with
  | Not_found
  | Scanf.Scan_failure _
  | Failure _
  | End_of_file ->
      Printf.eprintf "Warning: could not determine the OCaml version, \
                      assuming before 4.03\n";
      true

let () =
  if is_before_4_03 () then pkg_before_4_03 () else pkg_after_4_03 ()
