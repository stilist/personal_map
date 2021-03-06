# frozen_string_literal: true

require 'gpx'
require_relative '../to_geojson_path'
require_relative '../to_geojson_point'

class Gpx
  def initialize(root:, type:)
    @type = type
    files = ::Dir.glob("#{root}/manual reconstructions/gpx/*.gpx")

    processed = files.map { |f| process_file(f) }.
      flatten(1)

    @data = case @type
            when :path then ::ToGeojsonPath.new(data: processed).geojson
            when :point then ::ToGeojsonPoint.new(data: processed).geojson
            end
  end

  def geojson
    @data
  end

  private

  def process_file(path)
    data = ::GPX::GPXFile.new(gpx_file: path)

    case @type
    when :path then process_paths(data)
    when :point then process_points(data)
    end
  end

  def process_paths(data)
    data.tracks.map do |track|
      coordinates = track.segments.map do |segment|
        segment.points.map do |point|
          [
            point.lon,
            point.lat,
            point.elevation
          ].freeze
        end
      end

      {
        coordinates: coordinates,
        properties: {
          # @TODO This is true for the single file I have now, but it won't
          #   always be true.
          activity: 'walking',
        }.freeze,
      }.freeze
    end
  end

  def process_points(data)
    data.waypoints.map do |point|
      {
        coordinates: [
          point.lat,
          point.lon,
          point.elevation,
        ].freeze,
        name: '',
        note: nil,
        timestamp: point.time,
      }.freeze
    end
  end
end
