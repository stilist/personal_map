import {
  renderPaths,
  renderPoints
} from 'prebaked-geojson-map'
import addBaseLayers from './layers'
import map from './map'
// @note Import extra files so Webpack knows about them.
import './application.css'

addBaseLayers()
window.fetch('path_data.json')
  .then(response => response.json())
  .then(data => renderPaths(data, map))
window.fetch('point_data.json')
  .then(response => response.json())
  .then(data => renderPoints(data, map))
