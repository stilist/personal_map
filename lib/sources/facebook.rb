# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_point'

class Facebook
  def initialize(root:, type:)
    raw = ::File.read("#{root}/tagged_places.json")
    parsed = ::JSON.parse(raw)

    formatted = parsed['data'].map { |row| process_row(row) }
    @data = ::ToGeojsonPoint.new(data: formatted).
      geojson
  end

  def geojson
    @data
  end

  private

  def process_row(data)
    {
      name: data['place']['name'],
      note: nil,
      lat: data['place']['location']['latitude'],
      lng: data['place']['location']['longitude'],
      timestamp: data['created_time']
    }.freeze
  end
end
