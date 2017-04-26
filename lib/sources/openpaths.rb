# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'

class Openpaths
  def initialize(root:, type:)
    filename = ::Dir.glob("#{root}/openpaths_*.json").
      last

    raw = ::File.read(filename)
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
      {
        coordinates: [
          [
            [row['lon'], row['lat']].freeze
          ].freeze
        ].freeze
      }.freeze
    end
  end
end
