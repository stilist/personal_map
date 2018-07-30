# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_path'
require_relative '../to_geojson_point'

class GyroscopePlaces
  def initialize(root:, type:)
    @root = root
    raw = ::File.read("#{@root}/parsed.json")
    @json = ::JSON.parse(raw)

    @data = case type
      when :path then extract_paths
      when :point then extract_points
    end
  rescue ::Errno::ENOENT
    @data = []
  end

  def geojson
    @data
  end

  private

  def extract_paths
    paths = @json['paths'].map do |path|
      {
        coordinates: [path['points'].map(&:reverse)],
        properties: {
          activity: path['activity'],
        }
      }.freeze
    end

    ::ToGeojsonPath.new(data: paths).
      geojson
  end

  def extract_points
    points = @json['points'].map do |point|
      {
        lat: point['latitude'],
        lng: point['longitude'],
        name: point['name'],
      }.freeze
    end
    ::ToGeojsonPoint.new(data: points).
      geojson
  end
end
