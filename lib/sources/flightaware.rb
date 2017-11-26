# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'

class Flightaware
  def initialize(root:, type:)
    raw = ::File.read("#{root}/flightaware.json")
    processed = process_data(raw)

    @data = ::ToGeojsonPath.new(data: processed).
      geojson
  end

  def geojson
    @data
  end

  private

  def process_data(data)
    json = ::JSON.parse(data)

    json.map do |row|
      coordinates = row['points'].map do |point|
        [
          point['longitude'],
          point['latitude'],
          point['altitude'] * 0.3048,
        ].freeze
      end

      {
        coordinates: [coordinates],
        properties: {
          activity: 'airplane',
          endTime: row['endTime'],
          startTime: row['startTime'],
        }.freeze,
      }.freeze
    end
  end
end
