# frozen_string_literal: true

require 'json'

class ToGeojsonPath
  def initialize(data:)
    items = data.map { |row| build(row) }
    valid_items = items.reject { |row| row.flatten.empty? }

    @data = wrap(valid_items)
  end

  attr_reader :data

  def geojson
    ::JSON.dump(@data)
  end

  private

  def build(row)
    {
      type: 'Feature',
      geometry: {
        type: 'MultiLineString',
        coordinates: row[:coordinates],
      }.freeze,
      properties: (row[:properties] || {}),
    }.freeze
  end

  def wrap(points)
    {
      type: 'FeatureCollection',
      features: points
    }.freeze
  end
end
