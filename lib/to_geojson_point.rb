# frozen_string_literal: true

require 'json'

class ToGeojsonPoint
  def initialize(data:)
    points = data.map { |row| build_point(row) }
    valid_points = points.reject do |row|
      coords = row[:geometry][:coordinates]

      # @note This will cause problems if something ever is at 0,0 -- but that
      #   seems pretty unlikely.
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
        coordinates: [row[:lng], row[:lat], row[:altitude]].freeze,
      }.freeze,
      properties: {
        type: 'place',
        startTime: row[:startTime] || row[:timestamp],
        endTime: row[:endTime] || row[:timestamp],
        place: {
          name: row[:name],
          note: row[:note],
        }.freeze,
      }.freeze,
    }.freeze
  end

  def wrap_points(points)
    {
      type: 'FeatureCollection',
      features: points,
    }.freeze
  end
end
