# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_point'

class Reporter
  def initialize(root:, type:)
    files = ::Dir.glob("#{root}/*.json")

    processed = files.map { |f| read_file(f) }.
      flatten
    @data = ::ToGeojsonPoint.new(data: processed).
      geojson
  end

  def geojson
    @data
  end

  private

  def read_file(path)
    raw = ::File.read(path)
    data = ::JSON.parse(raw)

    data['snapshots'].select { |s| s.key?('location') }.
      map { |s| process_row(s['location']) }
  end

  def process_row(data)
     name = data['placemark'] ? data['placemark']['name'] : ''

    {
      name: name,
      note: nil,
      lat: data['latitude'],
      lng: data['longitude'],
      timestamp: data['timestamp']
    }.freeze
  end
end
