// @note Import the map here so it can start rendering while the path & point
//   data loads.
import map from './map'
import renderPaths from './render_paths'
import renderPoints from './render_points'
// @note Import extra files so Webpack knows about them.
import './application.css'

fetch('path_data.json')
  .then(response => response.json())
  .then(data => renderPaths(data.features))
fetch('point_data.json')
  .then(response => response.json())
  .then(data => renderPoints(data.features))
