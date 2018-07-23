# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Extract [Gyroscope Places](https://gyrosco.pe/places/) data that's been pre-processed with [the history importer](https://github.com/stilist/history_importer)

### Changed
- Support multiple exports in `google` and `moves_export` data paths
- Upgrade all gems
- Upgrade to Ruby 2.5.1
- Replace `SEQ:` with `SEQUENCE:` in iCalendar (`.ics`) files before parsing, to silence an unhelpful warning from the `icalendar` gem

## [0.0.2] - 2017-11-26
### Added
- Add location search
- Add `LICENSE` file
- Support point data in KML files

### Changed
- Upgrade all npm packages
- Fix lint errors that appeared after eslint upgrade
- Rebuild using `prebaked-geojson-map`
- Improve extracted altitude data (add support in two sources; convert feet to
  meters in three sources)

## 0.0.1 - 2017-04-25
### Added
- Initial release

[Unreleased]: https://github.com/stilist/personal_map/compare/v0.0.2...master
[0.0.2]: https://github.com/stilist/personal_map/compare/v0.0.1...0.0.2
