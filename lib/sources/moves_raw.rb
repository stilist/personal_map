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
    require 'byebug'
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
            coordinates: [activity['trackPoints'].map { |point| [point['lon'], point['lat']].freeze }],
            properties: {
              activity: activity['activity'] == 'wlk' ? 'walking' : 'car',
            }.freeze,
          }.freeze
        end
      end
    end
  end
end
