import 'leaflet.visualclick'
import 'd3'
import 'topojson'
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
