import L from 'leaflet'
import 'leaflet.visualclick'
import 'd3'
import 'topojson'
import 'leaflet-globe-minimap/src/Control.GlobeMiniMap'
import 'leaflet-geocoder-mapzen'
import {
  add as createMap
} from 'prebaked-geojson-map'

const map = createMap('map', {
  // @see https://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
  center: [39.833333, -98.583333],
  maxZoom: 18,
  visualClickEvents: 'dblclick',
  zoom: 5
})
export default map

new L.Control.GlobeMiniMap({
  land: '#ded',
  topojsonSrc: require('leaflet-globe-minimap/src/world.json'),
  water: 'rgba(128, 128, 145, 0.3)'
}).addTo(map)

L.control.geocoder('mapzen-o7EsTfi').addTo(map)
