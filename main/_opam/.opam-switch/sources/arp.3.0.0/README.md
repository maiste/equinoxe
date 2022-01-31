## ARP - Address Resolution Protocol purely in OCaml

v3.0.0

ARP is an implementation of the address resolution protocol (RFC826) purely in
OCaml.  It handles IPv4 protocol addresses and Ethernet hardware addresses only.

A [MirageOS](https://mirage.io) ARP implementation is in the `mirage` subdirectory.

Motivation for this implementation is [written up](https://hannes.nqsb.io/Posts/ARP).

## Documentation

[![Build Status](https://travis-ci.org/mirage/arp.svg?branch=master)](https://travis-ci.org/mirage/arp)

[API documentation](https://mirage.github.io/arp/) is available online.

## Installation

`opam install arp` will install this library, once you have installed OCaml (>=
4.08.0) and opam (>= 2.0.0).

Benchmarks require more opam libraries, namely `mirage-vnetif mirage-clock-unix
mirage-unix mirage-random-test`.  Use `make bench` to build and run it.
