# frozen_string_literal: true

require 'date'
require 'json'
require_relative '../parsers/kml'
require_relative '../to_geojson_point'

class Google
  def initialize(root:, type:)
    @root = root
    @data = case type
      when :path then extract_maps
      when :point then extract_location_history
    end
  end

  def geojson
    @data
  end

  private

  def extract_maps
    # TODO fix path lookup
    files = ::Dir["#{@root}/manual_walk_export/*.kml"]

    paths = files.map do |file|
      ::Parser::KML.new(path: file).
        data[:features].
        map { |row| row[:geometry].merge(properties: row[:properties]) }
    end

    ::ToGeojsonPath.new(data: paths.flatten(1)).
      geojson
  end

  def extract_location_history
    raw = ::File.read("#{@root}/Location\ History/LocationHistory.json")
    json = ::JSON.parse(raw)
    rows = json['locations'].map { |r| process_history_row(r) }
    ::ToGeojsonPoint.new(data: rows).
      geojson
  end

  def process_history_row(data)
    {
      name: '',
      note: nil,
      lat: data['latitudeE7'] / 1e7,
      lng: data['longitudeE7'] / 1e7,
      timestamp: Date.strptime(data['timestampMs'], '%Q')
    }.freeze
  end
end
