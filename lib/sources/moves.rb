# frozen_string_literal: true

require 'json'
require 'time'
require_relative '../to_geojson_path'
require_relative '../to_geojson_point'

class Moves
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
    files = ::Dir["#{@root}_export/*/geojson/daily/places/*.geojson"]
    points = files.map do |file|
      raw = File.read(file)
      json = ::JSON.parse(raw)
      process_point_data(json).flatten(1).
        compact
    end

    ::ToGeojsonPoint.new(data: points.flatten).
      geojson
  end

  def process_point_data(json)
    json['features'].map do |row|
      properties = row['properties']
      coordinates = row.dig('geometry', 'coordinates')

      {
        lat: coordinates[1],
        lng: coordinates[0],
        name: properties.dig('place', 'name'),
        startTime: Time.parse(properties['startTime']).iso8601,
        endTime: Time.parse(properties['endTime']).iso8601,
      }.freeze
    end

    # ::ToGeojsonPoint.new(data: processed).
    #   geojson
  end

  def extract_paths
    files = ::Dir["#{@root}_export/*/geojson/daily/storyline/*.geojson"]
    paths = files.map do |file|
      raw = File.read(file)
      json = ::JSON.parse(raw)
      process_path_data(json).flatten(1).
        compact
    end

    ::ToGeojsonPath.new(data: paths.flatten(1)).
      geojson
  end

  # Some activity segments don't include +startTime+ / +endTime+, but
  # they may have a +duration+ that can be used if the next segment
  # *does* include +startTime+ / +endTime+.
  #
  # @todo +activities+ usually includes its own +startTime+ / +endTime+ that
  #   can be used if there's not a subsequent event.
  def parse_activity_times(activities, index)
    activity = activities[index]

    startTime = activity.key?('startTime') ? Time.parse(activity['startTime']) : nil
    endTime = activity.key?('endTime') ? Time.parse(activity['endTime']) : nil
    if !startTime.nil? && activity['duration']
      next_activity = activities[index + 1]

      if next_activity && next_activity['startTime']
        endTime = Time.parse(next_activity['startTime'])
        startTime = endTime - activity['duration']
      end
    end

    [startTime, endTime].map { |t| t&.iso8601 }
  end

  def process_path_data(json)
    json['features'].select { |row| row['geometry']['type'] == 'MultiLineString' }.
      map do |row|
        activities = row['properties']['activities']
        coordinates = row['geometry']['coordinates']

        activities.each_with_index.map do |activity, index|
          # Remove flights -- the data is generally useless because of poor
          # connectivity in flight. (Distance is in meters; 50 kilometers ~= 31
          # miles.)
          next if activity['activity'] == 'airplane' &&
            activity['distance'] > 50_000
          next if activity['activity'] == 'transport' &&
            activity['distance'] > 500_000

          startTime, endTime = parse_activity_times(activities, index)
          {
            coordinates: [coordinates[index]].freeze,
            properties: {
              activity: activity['activity'],
              startTime: startTime,
              endTime: endTime,
            }.freeze,
          }.freeze
        end
      end
  end
end
