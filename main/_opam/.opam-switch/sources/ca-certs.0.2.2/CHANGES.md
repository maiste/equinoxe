# v0.2.2 (2021-10-27)

* Filter trailing certificate (if the data does not contain
  "-----BEGIN CERTIFICATE-----", it won't be a certificate) (#19 @hannesm)
* Avoid deprecated functions from fmt (#19 @hannesm)
* Remove rresult dependency (#19 @hannesm)
* Update GitHub actions (#19 @hannesm)

# v0.2.1 (2021-04-22)

* Update to X.509 0.13.0 API (#18, @hannesm)
* Respect NIX_SSL_CERT_FILE environment variable to support NixOS builds
  (reported by @sternenseemann in #16, fix in #17 by @hannesm)

# v0.2.0 (2021-03-05)

* Add Windows support (#14, @emillon)

# v0.1.3 (2020-11-17)

* Allow some certificates to fail decoding (#11, reported by @mattpallissard
  in mirleft/ocaml-x509#137)

# v0.1.2 (2020-10-12)

* Revise API, avoid temporary file creation on macos

# v0.1.1 (2020-10-11)

* Revise test suite to not connect to the network (to please opam's sandbox),
  instead use hardcoded certificate chains.

# v0.1.0 (2020-10-09)

* Tested on macos, Debian GNU/Linux, Ubuntu, Gentoo, Alpine, CentOS/RHEL 7,
  OpenSUSE, FreeBSD, OpenBSD
* Initial release
