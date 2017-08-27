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
    # Timestamp is included both as a float and as an ISO 8601 timestamp.
    timestamp = if data['timestamp'].is_a?(String) then Time.parse(data['timestamp'])
                # +timestamp+ doesn't include a leading +1+.
                else Time.at(data['timestamp'] + 10e8).iso8601
                end

    {
      coordinates: [
        data['latitude'],
        data['longitude'],
        nil,
      ].freeze,
      name: data.dig('placemark', 'name'),
      timestamp: timestamp,
    }.freeze
  end
end
