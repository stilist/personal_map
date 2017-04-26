import L from 'leaflet'
import 'leaflet.markercluster'
import map from './map'

const pointsOptions = {
  pointToLayer(obj, coordinates) {
    const mark = L.marker(coordinates)
    if (obj.properties.place.name) mark.bindPopup(obj.properties.place.name)

    return mark
  },
  style: {
    clickable: true,
  },
}

const clusterOptions = {
  disableClusteringAtZoom: 18
}

export default function renderPoints(points) {
  const parsedPoints = L.geoJson(points, pointsOptions)

  const cluster = L.markerClusterGroup(clusterOptions)
    .addLayer(parsedPoints)

  map.addLayer(cluster)
}
