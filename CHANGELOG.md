# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Fixed
- Upgrade `acorn`, `kind-of`, `minimist`, `serialize-javascript`, `serve`, and `yargs-parser` dependencies to address vulnerabilities

## [0.0.3] - 2019-11-16
### Added
- Extract [Gyroscope Places](https://gyrosco.pe/places/) data that's been pre-processed with [the history importer](https://github.com/stilist/history_importer)

### Changed
- Support multiple exports in `google` and `moves_export` data paths
- Upgrade all gems
- Upgrade to Ruby 2.5.1
- Replace `SEQ:` with `SEQUENCE:` in iCalendar (`.ics`) files before parsing, to silence an unhelpful warning from the `icalendar` gem
- Import Moves data from `daily` GeoJSON files instead of `full` files, to simplify merging data from multiple Moves accounts
- Sort paths and points by `startTime` when possible
- Upgrade Ruby to 2.6.5
- Upgrade `activesupport`, `nokogiri`, `rake`, `rubyzip` gems
- Upgrade `css-loader`, `debug`, `eslint`, `eslint-config-standard`, `eslint-plugin-node`, `eslint-plugin-promise`, `eslint-plugin-standard`, `file-loader`, `leaflet`, `lodash`, `mixin-deep`, `serve`, `style-loader`, `url-loader`, `webpack`, `whatwg-fetch` packages

### Fixed
- Handle case that `HISTORY_DATA_PATH` doesn't have data for various parsers
- Upgrade dependencies to address all known vulnerabilities

### Removed
- Remove `leaflet-globe-minimap`, and `d3`, `exports-loader`, `imports-loader`, and `url-loader` dependencies that supported it
- Remove `leaflet-geocoder-mapzen` -- Mapzen's services were disabled in early 2018

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

[Unreleased]: https://github.com/stilist/personal_map/compare/v0.0.3...master
[0.0.3]: https://github.com/stilist/personal_map/compare/v0.0.2...0.0.3
[0.0.2]: https://github.com/stilist/personal_map/compare/v0.0.1...0.0.2
