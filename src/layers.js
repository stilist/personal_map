import {
  addLayer
} from 'prebaked-geojson-map'
import map from './map'

const baseLayers = {
  'mapbox.satellite': [
    'Mapbox Satellite',
    'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
    'Map data © <a href=http://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors © <a href=https://www.mapbox.com/about/maps/>Mapbox</a>'
  ],
  'stilist/ciun4oy6p007y2ino8xwsdbjl': [
    'Terrain',
    'https://api.mapbox.com/styles/v1/{id}/tiles/256/{z}/{x}/{y}?access_token={accessToken}',
    'Map data © <a href=http://www.openstreetmap.org/copyright>OpenStreetMap</a> contributors © <a href=https://www.mapbox.com/about/maps/>Mapbox</a>'
  ]
}
// @note You can get your own Mapbox access token:
// @see https://www.mapbox.com/help/define-access-token/
const accessToken = 'pk.eyJ1Ijoic3RpbGlzdCIsImEiOiJjajF5ZTNmYTYwMGl5MzJrMm8yMW5pNXFuIn0.JPyzMvSpcnqJZSVV4TxZJg'
function addBaseLayers () {
  for (const id in baseLayers) {
    const [name, urlTemplate, attribution] = baseLayers[id]

    map.fire('addBaseLayer', {
      baseLayer: addLayer(urlTemplate, {
        accessToken,
        attribution,
        id
      }),
      key: name
    })
  }
}
export default addBaseLayers
