import L from 'leaflet'
import 'leaflet.markercluster'
import map from './map'
import isInTimeRange from './is_in_time_range'

const rangeStart = new Date('1900-01-01T00:00:00Z')
const rangeEnd = new Date('2100-01-13T00:00:00Z')

const pointsOptions = {
  filter: feature => {
    return isInTimeRange(feature.properties.startTime,
      feature.properties.endTime,
      rangeStart,
      rangeEnd)
  },
  pointToLayer (obj, coordinates) {
    const mark = L.marker(coordinates)
    if (obj.properties.place.name) mark.bindPopup(obj.properties.place.name)

    return mark
  },
  style: {
    clickable: true
  }
}

const clusterOptions = {
  disableClusteringAtZoom: 18
}

export default function renderPoints (points) {
  const parsedPoints = L.geoJson(points, pointsOptions)

  const cluster = L.markerClusterGroup(clusterOptions)
    .addLayer(parsedPoints)

  map.addLayer(cluster)
}
