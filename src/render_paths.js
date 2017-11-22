import L from 'leaflet'
import map, { baseLayers } from './map'
import isInTimeRange from './is_in_time_range'

/**
 * This list of colors is taken from the Moves documentation.
 *
 * You can generate the list with:
 *
 *   let rows = jQuery('table:last tbody tr').toArray()
 *   let rule = (row) => `  ${row.name}: '${row.color}',`
 *   let ruleForRow = ($cells) => rule({ name: $cells.first().text(), color: $cells.last().text() })
 *   let colors = rows.map((row) => ruleForRow(jQuery(row).children())).join('\n')
 *   console.log(`const activities = {\n${colors}\n}`)
 *
 * @see https://dev.moves-app.com/docs/api_activity_list#activity_table
 */
const activities = {
  cycling: '#00cdec',
  indoor_cycling: '#00cdec',
  running: '#f660f4',
  running_on_treadmill: '#f660f4',
  walking: '#00d55a',
  walking_on_treadmill: '#00d55a',
  airplane: '#848484',
  boat: '#848484',
  bus: '#848484',
  car: '#848484',
  escalator: '#848484',
  ferry: '#848484',
  funicular: '#848484',
  motorcycle: '#848484',
  sailing: '#848484',
  scooter: '#848484',
  train: '#848484',
  tram: '#848484',
  transport: '#848484',
  underground: '#848484',
  aerobics: '#bc4fff',
  american_football: '#c93838',
  badminton: '#11d1cb',
  ballet: '#ff82a8',
  bandy: '#22b5b0',
  baseball: '#fa7070',
  basketball: '#fc6f0a',
  beach_volleyball: '#ffb938',
  bodypump: '#d1416c',
  bowling: '#d68b00',
  boxing: '#c93838',
  circuit_training: '#eb4db4',
  cleaning: '#96cc00',
  climbing: '#c96a26',
  cricket: '#96cc00',
  cross_country_skiing: '#2183b8',
  curling: '#11d1cb',
  dancing: '#963fcc',
  disc_ultimate: '#4a963c',
  downhill_skiing: '#00a6ff',
  elliptical_training: '#bc4fff',
  fencing: '#42bdff',
  floorball: '#22b5b0',
  golfing: '#44c42d',
  gym_training: '#e82c64',
  gymnastics: '#9c27e6',
  handball: '#3e5ec7',
  hockey: '#22b5b0',
  kayaking: '#1390d4',
  kettlebell: '#eb4db4',
  kite_surfing: '#00a6ff',
  lacrosse: '#4a963c',
  martial_arts: '#fa4646',
  paddling: '#1390d4',
  paintball: '#e82c64',
  parkour: '#c96a26',
  petanque: '#42bdff',
  pilates: '#ff82a8',
  polo: '#fa4646',
  racquetball: '#2183b8',
  riding: '#995e34',
  roller_skiing: '#2183b8',
  rollerblading: '#e0bb00',
  rollerskating: '#ffa361',
  rowing: '#1390d4',
  rugby: '#238755',
  scuba_diving: '#11d1cb',
  skateboarding: '#ff8c3b',
  skating: '#1390d4',
  snowboarding: '#8765f7',
  snowshoeing: '#3360f2',
  soccer: '#4a963c',
  spinning: '#ffa600',
  squash: '#ab91ff',
  stair_climbing: '#ffa600',
  stretching: '#8ca7ff',
  surfing: '#00a6ff',
  swimming: '#42bdff',
  table_tennis: '#3360f2',
  tennis: '#ffb938',
  volleyball: '#8ca7ff',
  water_polo: '#cc68c9',
  weight_training: '#cc68c9',
  wheel_chair: '#358f8c',
  windsurfing: '#00a6ff',
  wrestling: '#fc6f0a',
  yoga: '#a655a3',
  zumba: '#fa5788'
}

const dashes = {
  airplane: '5, 5, 1, 5',
  bus: '5, 5',
  car: '5, 5'
}

const rangeStart = new Date('1900-01-01T00:00:00Z')
const rangeEnd = new Date('2100-01-13T00:00:00Z')

const activityOptions = {
  filter: feature => {
    return isInTimeRange(feature.properties.startTime,
      feature.properties.endTime,
      rangeStart,
      rangeEnd)
  },
  style: feature => {
    let activity = feature.properties.activity
    let color = activities[activity] || '#fc0'

    let options = {
      clickable: false,
      color,
      opacity: 0.65,
      weight: 2
    }
    if (dashes[activity]) options.dashArray = dashes[activity]

    return options
  }
}

export default function renderActivities (allFeatures) {
  const grouped = allFeatures.reduce((memo, feature) => {
    const key = feature.properties.activity

    if (!memo[key]) memo[key] = []
    memo[key].push(feature)

    return memo
  }, {})

  const layers = {}
  for (let activity of Object.keys(grouped)) {
    layers[activity] = L.geoJson(grouped[activity], activityOptions).addTo(map)
  }
  L.control
    .layers(baseLayers, layers)
    .addTo(map)
}
