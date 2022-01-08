<div align="center">
  <h1>Equinoxe</h1>
  <strong>An Equinix API client library for OCaml</strong>
</div>

<div align="center">
<br />
  
[![License](https://img.shields.io/github/license/maiste/equinoxe?style=flat-square)](LICENSE)
[![Documentation](https://img.shields.io/badge/documentation-online-blue?style=flat-square)](https://maiste.github.io/equinoxe)
</div>

## About

**Equinoxe** is a library to interact with the Equinix [API](https://metal.equinix.com/developers/api/) (formerly known as Packet) in *OCaml*. Users can use it to gather information, deploy machines or manage your organization within an *OCaml* program. It comes with a CLI, `equinoxe-cli`, that packs most of the functionalities of the API.

 :warning: This repository is based on the official API but is not an official work from Equinix. This work is still in active development so the API **might not be stable**.

## Getting started

### Installation

To install the **Equinoxe** via `opam`:
```sh
$ opam install equinoxe
```

To install the `dev` version of **Equinoxe**, you have to install it via pinning:
```sh
$ opam pin add equinoxe.dev git@github.com:maiste/equinoxe
$ opam install equinoxe
```

### Usage

The goal is to provide a minimal set of functions to interact with Equinix API:

## Issues

Report issues using the [GitHub bugtracker](https://github.com/maiste/equinoxe/issues)

## License

This project is under the [MIT License](LICENSE)
