'use strict'

import L from 'leaflet'
import 'leaflet.visualclick'
import 'd3'
import 'topojson'
import 'leaflet-globe-minimap/src/Control.GlobeMiniMap'

// Fix image URL lookup for Webpack.
//
// @see https://github.com/Leaflet/Leaflet/issues/4968
L.Marker.prototype.options.icon = L.icon({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
})

const baseLayerNames = [
  ['CartoDB dark', 'cartodb.light_all'],
  ['Open Street Map', 'osm'],
  ['Terrain', 'stilist/ciun4oy6p007y2ino8xwsdbjl'],
  ['Mapbox Satellite', 'mapbox.satellite'],
]

const baseLayerURLs = {
  cartodb: 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
  mapbox: 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
  osm: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  stilist: 'https://api.mapbox.com/styles/v1/{id}/tiles/256/{z}/{x}/{y}?access_token={accessToken}',
}

const attribution = [
  'Map data © <a href=http://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors',
  '© <a href=https://carto.com/attribution>CARTO</a>',
  '© <a href=https://www.mapbox.com/about/maps/>Mapbox</a>',
].join(', ')

export const baseLayers = baseLayerNames.reduce((memo, layer) => {
  const stylePrefix = layer[1].match(/^(\w+)/)[0]
  const baseLayerURL = baseLayerURLs[stylePrefix]

  const tileLayer = L.tileLayer(baseLayerURL, {
    attribution: attribution,
    // @note You can get your own Mapbox access token:
    // @see https://www.mapbox.com/help/define-access-token/
    accessToken: 'pk.eyJ1Ijoic3RpbGlzdCIsImEiOiJjajF5ZTNmYTYwMGl5MzJrMm8yMW5pNXFuIn0.JPyzMvSpcnqJZSVV4TxZJg',
    id: layer[1],
  })
  memo[layer[0]] = tileLayer

  return memo
}, {})

const mapEl = document.createElement('div')
mapEl.setAttribute('id', 'map')
document.body.appendChild(mapEl)

const map = L.map(mapEl, {
  // @see https://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
  center: [39.833333, -98.583333],
  layers: baseLayerNames.map(layer => baseLayers[layer[0]]),
  visualClickEvents: 'dblclick',
  zoom: 5,
})
export default map

new L.Control.GlobeMiniMap({
  topojsonSrc: require('url-loader?limit=1!leaflet-globe-minimap/src/world.json'),
}).addTo(map)
