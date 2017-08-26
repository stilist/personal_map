# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'

class MovesRaw
  def initialize(root:, type:)
    files = ::Dir.glob("#{root}/*.json")
    processed = files.map { |f| read_file(f) }
      .flatten
      .compact

    @data = ::ToGeojsonPath.new(data: processed)
      .geojson
  end

  def geojson
    @data
  end

  private

  def read_file(path)
    raw = ::File.read(path)
    raw.sub!(/\},\]\}\Z/, '}]}')
    data = ::JSON.parse(raw)

    process_data(data)
  end

  def process_data(data)
    activity_table = {
      'run' => 'running',
      # +trp+ is technically 'transport', but since the output data doesn't
      # include flights this almost certainly means driving ('car').
      'trp' => 'car',
      'wlk' => 'walking',
    }.freeze

    data['export'].map do |date|
      next if date['segments'].nil?
      with_points = date['segments'].select { |segment| segment['type'] == 'move' }

      with_points.map do |segment|
        segment['activities'].map do |activity|
          # Remove flights -- the data is generally useless because of poor
          # connectivity in flight. (Distance is in meters; 1 million meters ~=
          # 621 miles.)
          next if activity['distance'] > 1_000_000

          {
            coordinates: [activity['trackPoints'].map { |point| [point['lon'], point['lat'], nil].freeze }],
            properties: {
              activity: activity_table[activity['activity']],
              startTime: Time.parse(activity['startTime']).iso8601,
              endTime: Time.parse(activity['endTime']).iso8601,
            }.freeze,
          }.freeze
        end
      end
    end
  end
end
