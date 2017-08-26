# frozen_string_literal: true

require 'json'
require 'time'
require_relative '../to_geojson_path'

class Moves
  def initialize(root:, type:)
    raw = ::File.read("#{root}_export/geojson/full/storyline.geojson")
    processed = process_data(raw).flatten(1).
      compact

    @data = ::ToGeojsonPath.new(data: processed).
      geojson
  end

  def geojson
    @data
  end

  private

  # Some activity segments don't include +startTime+ / +endTime+, but
  # they may have a +duration+ that can be used if the next segment
  # *does* include +startTime+ / +endTime+.
  #
  # @todo +activities+ usually includes its own +startTime+ / +endTime+ that
  #   can be used if there's not a subsequent event.
  def parseTimes(activities, index)
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

  def process_data(data)
    json = ::JSON.parse(data)

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

          startTime, endTime = parseTimes(activities, index)
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
