# frozen_string_literal: true

require 'csv'
require 'time'
require_relative '../to_geojson_path'
require_relative '../to_geojson_point'

class Gyroscope
  def initialize(root:, type:)
    @root = root
    @data = case type
      when :path then extract_paths
      when :point then extract_points
    end
  end

  def geojson
    @data
  end

  private

  def extract_points
    # +gyroscope-NAME-gvisits-export.csv+: Gyroscope Places
    # +gyroscope-NAME-visits-export.csv+: Moves data imported to Gyroscope
    files = ::Dir["#{@root}/partial exports/gyroscope/**/*visits-export.csv"]

    points = files.map do |file|
      raw = File.read(file)
      csv = ::CSV.parse(raw, headers: :first_row)
      process_point_data(csv).flatten(1).
        compact
    end

    ::ToGeojsonPoint.new(data: points.flatten).
      geojson
  end

  def process_point_data(csv)
    valid_rows(csv).map do |row|
      {
        lat: row[3],
        lng: row[4],
        name: row[2],
        startTime: fix_timestamp(row[0]),
        endTime: fix_timestamp(row[1]),
      }.freeze
    end
  end

  def extract_paths
    # +gyroscope-NAME-travels-export.csv+: Gyroscope Places
    files = ::Dir["#{@root}/partial exports/gyroscope/**/*-travels-export.csv"]

    paths = files.map do |file|
      raw = File.read(file)
      csv = ::CSV.parse(raw, headers: :first_row)
      process_path_data(csv).flatten(1).
        compact
    end

    ::ToGeojsonPath.new(data: paths.flatten(1)).
      geojson
  end

  def process_path_data(csv)
    valid_rows(csv).map do |row|
      next if row[3].nil?

      raw_coordinates = row[3].gsub('(', '[')
        .gsub(')', ']')
      coordinates = eval("[#{raw_coordinates}]").map do |pair|
        pair.reverse
      end

      corrected_activity = row[2] == 'driving' ? 'car' : row[2]

      {
        coordinates: [coordinates],
        properties: {
          activity: corrected_activity,
          startTime: fix_timestamp(row[0]),
          endTime: fix_timestamp(row[1]),
        }
      }.freeze
    end
  end

  def fix_timestamp(timestamp)
    timestamp.sub(/-(\d{2}:)/, 'T\1')
  end

  def valid_rows(csv)
    last_index = csv.first.length - 1

    csv.select do |row|
      row[last_index] =~ /(?:gyroscope|moves|places)/
    end
  end
end
