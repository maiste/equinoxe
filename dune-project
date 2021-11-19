(lang dune 2.9)
(generate_opam_files true)

(package
  (name equinoxe)
  (version 0.1.0)
  (license MIT)
  (authors
    "Étienne Marais <etienne@maiste.fr>")
  (maintainers
    "Étienne Marais <etienne@maiste.fr>")
  (synopsis "An OCaml wrapper for the Equinix API")
  (description "Equinoxe is an OCaml wrapper for the Equinix API.")
  (source (github maiste/equinoxe))
  (documentation "maiste.github.io/equinoxe")
  (depends
    (ocaml (>= 4.08.0))
    (ocamlformat :dev)
    (ocaml-lsp-server :dev)
    (odoc :with-doc)
    (ezjsonm (>= 1.3.0))
    (ezcurl (>= 0.2.1))))
