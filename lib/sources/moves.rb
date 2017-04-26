# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'

class Moves
  def initialize(root:, type:)
    raw = ::File.read("#{root}_export/geojson/full/storyline.geojson")
    processed = process_data(raw).flatten(1).
      compact

    @data = ::ToGeojsonPath.new(data: processed).
      geojson
  end

  def geojson
    @data
  end

  private

  def process_data(data)
    json = ::JSON.parse(data)

    json['features'].select { |row| row['geometry']['type'] == 'MultiLineString' }.
      map do |row|
        activities = row['properties']['activities']
        coordinates = row['geometry']['coordinates']

        activities.each_with_index.map do |activity, index|
          # Remove flights -- the data is generally useless because of poor
          # connectivity in flight. (Distance is in meters; 50 kilometers ~= 31
          # miles.)
          next if activity['activity'] == 'airplane' &&
            activity['distance'] > 50_000

          {
            coordinates: [coordinates[index]].freeze,
            properties: {
              activity: activity['activity'],
            }.freeze,
          }.freeze
        end
      end
  end
end
