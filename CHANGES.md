## Unreleased

### Added

- Introduce the `Device.update` function (#76, @maiste)
- Introduce the `Device.is_available` function (#77, @maiste)
- Introduce the `Device.safe_create` function (#77, @maiste)

### Changed

- Extracted `Backend` as a package name `Terminus` and update the codebase to support it (#81, @maiste)
- Update the `Device.build` function to support `tags` (#76, @maiste)

## 0.2.0

### Added

- Add a Cohttp client version, with a specific package (#60, @maiste)
- Add a statically-typed API (#68, #71, @maiste)
- Add unit tests to mock Equinix api (#70, @art-w)

### Changed

- Rewrite the API using `io` monad (#63, @art-w)
- Uniform error handling between Cohttp and HLC (#69, @art-w)
- Update `Equinoxe-cohttp` and `Equinix-hlc` to support only new API (#71, @maiste)

### Removed

- Remove `JSON` module and use `Ezjsonm` directly (#63, @art-w)
- Remove timeout support from Cohttp (#69, @art-w)
- Remove old API with JSON from `Equinoxe`, `Equinoxe-cohttp` and `Equinoxe-hlc` (#68, #71, @maiste)
- Remove `bin` directory (#70, @maiste)

## 0.1.0

### Added

- Import a default http client to communicate with the Equinix API (#25, #22, #23, @maiste)
- Add some user commands (#24, @maiste)
- Add some organization commands (#33, @maiste)
- Add some projects commands (#36, #37, @maiste)
- Add some devices commands (#37, @maiste)
- JSON manager module (#6, @maiste)
- IP module (#47, @maiste)
- Generate a test system (#42, @maiste)
- Add a README (#26, #27, @maiste)
