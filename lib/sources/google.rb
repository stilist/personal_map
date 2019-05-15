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
    # Only use files with a name formatted like a date.
    files = ::Dir["#{@root}/complete exports/google/**/My Maps/*.kmz"].select do |path|
      ::File.basename(path, '.kmz') =~ /\A\d{4}/
    end

    paths = files.map do |file|
      ::Parser::KML.new(path: file, type: :path).
        data
    end

    ::ToGeojsonPath.new(data: paths.flatten(1)).
      geojson
  end

  def extract_location_history
    files = ::Dir["#{@root}/complete exports/google/**/Location History/Location History.json"]
    points = files.map do |file|
      raw = File.read(file)
      json = ::JSON.parse(raw)
      rows = json['locations'].map { |r| process_history_row(r) }
    end

    ::ToGeojsonPoint.new(data: points.flatten(1)).
      geojson
  end

  def process_history_row(data)
    {
      coordinates: [
        data['latitudeE7'] / 1e7,
        data['longitudeE7'] / 1e7,
        data.fetch('altitude', 0) * 0.3048,
      ],
      name: '',
      note: nil,
      timestamp: Time.strptime(data['timestampMs'], '%Q').iso8601,
    }.freeze
  end
end
