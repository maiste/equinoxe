(lang dune 2.9)
(generate_opam_files true)

(name equinoxe)
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
    (ezjsonm (>= 1.3.0))
    (lwt (>= 5.3.0))
    (odate (>= 0.6))
    (alcotest :with-test)
    (alcotest-lwt :with-test)
    (ppx_deriving :with-test)
    (odoc :with-doc))
  (conflicts
    (result (< 1.5))))

(package
  (name equinoxe-hlc)
  (synopsis "Equinoxe with the http-lwt-client request handler")
  (description
    "Equinoxe-hlc is an implementation of the Equinoxe library using http-lwt-client.")
  (depends
    (equinoxe (= :version))
    terminus-hlc
    (alcotest :with-test)
    (alcotest-lwt :with-test)
    (odoc :with-doc))
  (conflicts
    (result (< 1.5))))

(package
  (name equinoxe-cohttp)
  (synopsis "Equinoxe with the cohttp-lwt-unix request handler")
  (description
    "Equinoxe-cohttp is an implementation of the Equinoxe library using cohttp-lwt-unix.")
  (depends
    (equinoxe (= :version))
    terminus-cohttp
    (alcotest :with-test)
    (alcotest-lwt :with-test)
    (odoc :with-doc))
  (conflicts
    (result (< 1.5))))

