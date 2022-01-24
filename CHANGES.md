## Unreleased

### Added

- Add a Cohttp client version, with a specific package (#60, @maiste)
- Add Orga module to a statically-typed API (#68, @maiste)

### Changed

- Rewrite the API using `io` monad (#63, @art-w)
- Uniform error handling between Cohttp and HLC (#69, @art-w)

### Removed

- Remove `JSON` module and use `Ezjsonm` directly (#63, @art-w)
- Remove modules from the old JSON Api module (#68, @maiste)
- Remove timeout support from Cohttp (#69, @art-w)

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
