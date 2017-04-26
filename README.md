# Personal map

Collects location data from your [history export](https://github.com/stilist/history_importer).

## Usage

*Note:* you’ll need to adjust [`HISTORY_DATA_PATH`](https://github.com/stilist/history_importer#using-crontab-to-run-the-importer-automatically) to match what you’re using for `history_importer`.

`HISTORY_DATA_PATH=~/history ruby extract_data.rb`

This will write data to `public/path_data.json` and `public/point_data.json` as [GeoJSON](http://geojson.org).

## Viewing in a browser

You'll need to install either [npm](https://www.npmjs.com) or [Yarn](https://yarnpkg.com), then run `npm install` or `yarn install`. This will install the package dependencies and automatically run the `build` script to compile the JavaScript for the page.

To display the data, open `public/index.html` in your browser. This will *mostly* work -- the map and your data will load, but some images may be missing because of how the browser resolves paths. To get the ideal experience you'll need to use [Pow](http://pow.cx) or something similar, pointed at the `public/` directory.

This project includes several base layers for the map; you can add your own in `src/map.js` by updating `baseLayerNames` and `baseLayerURLs`.
