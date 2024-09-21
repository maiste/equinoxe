<div align="center">
  <h1>Equinoxe</h1>
  <strong>An Equinix API client library for OCaml</strong>
</div>

<div align="center">
<br />
  
[![License](https://img.shields.io/github/license/maiste/equinoxe?style=flat-square)](LICENSE)
[![Documentation](https://img.shields.io/badge/documentation-online-blue?style=flat-square)](https://maiste.github.io/equinoxe)
</div>

## Depracation ❄

As Equinix does not let me recreate an individual account to finish the work (my demand has been rejected), this repository is archived now. Feel free to fork it if you want to keep working on it and you have an access to their infrastructure. I will move on with another provider.

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

The goal is to provide a minimal set of functions to interact with Equinix API. To run the the actions available with `Equinoxe` you have to install a specific backend (http request client). There are currently two backends: `equinoxe-hlc` which relies on `Httpaf` and `equinoxe-cohttp` which relies on `Cohttp`. You can also provide your own custom backend:
```OCaml
module My_Backend : Equinoxe.Backend

module Api = Equinoxe.Make (My_Backend)
```

## Issues

Report issues using the [GitHub bugtracker](https://github.com/maiste/equinoxe/issues)

## License

This project is under the [MIT License](LICENSE)
