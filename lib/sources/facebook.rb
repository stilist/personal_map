# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_point'

class Facebook
  def initialize(root:, type:)
    files = ::Dir["#{root}/complete exports/facebook/**/location/location_history.json"]

    points = files.map do |file|
      raw = ::File.read(file)
      data = ::JSON.parse(raw)
      process_point_data(data).flatten(1).
        compact
    end

    @data = ::ToGeojsonPoint.new(data: points.flatten).
      geojson
  rescue ::Errno::ENOENT
    @data = []
  end

  def geojson
    @data
  end

  private

  def process_point_data(data)
    data['location_history_all'].map do |entry|
      {
        name: entry['name'],
        note: nil,
        lat: entry['coordinate']['latitude'],
        lng: entry['coordinate']['longitude'],
        timestamp: data['creation_timestamp'],
      }.freeze
    end
  end
end
