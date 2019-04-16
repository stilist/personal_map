# frozen_string_literal: true

require 'json'
require_relative '../parsers/kml'
require_relative '../to_geojson_point'

class Foursquare
  def initialize(root:, type:)
    json_files = ::Dir.glob("#{root}/complete exports/foursquare/**/unconfirmed visits.json")

    json_points = json_files.map do |file|
      raw = ::File.read(file)
      data = ::JSON.parse(raw)
      process_json_point_data(data).flatten(1).
        compact
    end

    kml_file = ::Dir.glob("#{root}/partial exports/foursquare/**/*.kml").
      last
    kml_points = ::Parser::KML.new(path: kml_file, type: :point).
      data

    points = [
      json_points,
      kml_points,
    ].flatten

    @data = ::ToGeojsonPoint.new(data: points).
      geojson
  rescue ::Errno::ENOENT
    @data = []
  end

  def geojson
    @data
  end

  private

  def process_json_point_data(data)
    data['items'].each do |entry|
      out = {
        note: nil,
      }

      if entry.key?('venue')
        out.merge!({
          name: entry['venue']['name'],
          lat: entry['lat'],
          lng: entry['lng'],
        })
      else
        out.merge!({
          name: entry['location']['name'],
          lat: entry['location']['lat'],
          lng: entry['location']['lng'],
        })
      end

      if entry['endTime'] && entry['endTime'] > 0
        out.merge({
          startTime: entry['startTime'],
          endTime: entry['endTime'],
        })
      else
        out.merge(timestamp: entry['createdAt'])
      end
    end
  end
end
