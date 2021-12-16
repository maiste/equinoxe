(lang dune 2.9)
(generate_opam_files true)

(source (github maiste/equinoxe))
(license MIT)
(authors
  "Étienne Marais <etienne@maiste.fr>")
(maintainers
  "Étienne Marais <etienne@maiste.fr>")
(documentation "maiste.github.io/equinoxe")

(package
  (name equinoxe)
  (synopsis "An OCaml wrapper for the Equinix API")
  (description "Equinoxe is an OCaml wrapper for the Equinix API.")
  (depends
    (ocaml (>= 4.08.0))
    (ocamlformat :dev)
    (ocaml-lsp-server :dev)
    (odoc :with-doc)
    (ezjsonm (>= 1.3.0))
    http-lwt-client))

(package
  (name equinoxe-bin)
  (synopsis "A CLI for Equinix (ex Packet)")
  (description "Equinoxe is a CLI for Equinix you can use to interact with.")
  (depends
    equinoxe
    cmdliner))
