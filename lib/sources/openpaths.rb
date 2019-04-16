# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'

class Openpaths
  def initialize(root:, type:)
    filename = ::Dir.glob("#{root}/partial exports/openpaths/openpaths_*.json").
      last

    raw = ::File.read(filename)
    processed = process_data(raw)

    @data = ::ToGeojsonPath.new(data: processed).
      geojson
  rescue ::TypeError
    @data = []
  end

  def geojson
    @data
  end

  private

  def process_data(data)
    json = ::JSON.parse(data)

    json.map do |row|
      {
        coordinates: [
          [
            [row['lat'], row['lon'], row['alt']].freeze
          ].freeze
        ].freeze,
        properties: {
          startTime: Time.at(row['t']).iso8601,
          endTime: Time.at(row['t']).iso8601,
        },
      }.freeze
    end
  end
end
