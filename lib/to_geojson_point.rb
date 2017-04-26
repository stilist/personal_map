# frozen_string_literal: true

require 'json'

class ToGeojsonPoint
  def initialize(data:)
    points = data.map { |row| build_point(row) }
    valid_points = points.reject do |row|
      coords = row[:geometry][:coordinates]

      coords[0].nil? || (coords[0] == 0 && coords[1] == 0)
    end

    @data = wrap_points(valid_points)
  end

  attr_reader :data

  def geojson
    ::JSON.dump(@data)
  end

  private

  def build_point(row)
    {
      type: 'Feature',
      geometry: {
        type: 'Point',
        coordinates: [row[:lng], row[:lat]].freeze
      }.freeze,
      properties: {
        type: 'place',
        startTime: row[:timestamp],
        endTime: row[:timestamp],
        place: {
          name: row[:name],
          note: row[:note] || ''
        }.freeze
      }.freeze
    }.freeze
  end

  def wrap_points(points)
    {
      type: 'FeatureCollection',
      features: points
    }.freeze
  end
end
