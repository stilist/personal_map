# frozen_string_literal: true

require 'json'

class ToGeojsonPath
  def initialize(data:)
    items = data.map { |row| build(row) }

    @data = wrap(items)
  end

  attr_reader :data

  def geojson
    ::JSON.dump(@data)
  end

  private

  DEFAULT_PROPERTIES = {
    activity: nil,
    name: nil,
    note: nil,
    startTime: nil,
    endTime: nil,
  }.freeze

  def build(row)
    {
      type: 'Feature',
      geometry: {
        type: 'MultiLineString',
        coordinates: row[:coordinates],
      }.freeze,
      properties: row[:properties] || DEFAULT_PROPERTIES,
    }.freeze
  end

  def wrap(points)
    {
      type: 'FeatureCollection',
      features: points
    }.freeze
  end
end
