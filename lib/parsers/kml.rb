# frozen_string_literal: true

require 'nokogiri'
require_relative '../to_geojson_path'
require_relative '../to_geojson_point'

module Parser
  class KML
    def initialize(path:, type:)
      file = ::File.open(::File.expand_path(path))

      document = ::Nokogiri::XML(file)
      segments = document.css('Folder')

      @data = case type
        when :path
          parsed = segments.map { |segment| extract_paths(segment) }.
            flatten.
            compact
          ::ToGeojsonPath.new(data: parsed).data
        when :point
          parsed = segments.map { |segment| extract_points(segment) }.
            flatten.
            compact
          ::ToGeojsonPoint.new(data: parsed).geojson
      end
    end

    attr_reader :data

    def geojson
      @data.geojson
    end

    private

    def extract_paths(segment)
      coordinates = segment.css('LineString > coordinates')
      return if coordinates.empty?

      name = segment.css('> name').text
      # If `name` has a space it's Google Maps' default 'Directions from…'
      # label.
      activity = name =~ /\s/ ? nil : name

      points = coordinates.text.split(' ')
      {
        coordinates: [points.map { |point| extract_coordinates(point) }].freeze,
        properties: {
          activity: activity,
        }.freeze,
      }.freeze
    end

    def extract_points(segment)
      points = segment.css('Placemark').
        reject { |placemark| placemark.css('> Point').empty? }

      points.map do |point|
        note = point.css('description').text.slice(point.css('name').text)

        {
          coordinates: extract_coordinates(point.css('coordinates').text),
          name: point.css('name').text,
          # Foursquare description is always in the format
          #   @<a href="https://foursquare.com/v/...">[name]</a>
          # If the user has included a comment the `</a>` is followed by
          # `- [user comment]`.
          note: note,
          timestamp: Time.parse(point.css('published').text).iso8601,
        }.freeze
      end
    end

    # @example
    #   extract_coordinates("-122.6817855911751,45.52572423965363")
    #   #=> [-122.6817855911751, 45.52572423965363, nil]
    #   extract_coordinates("-76.97092,40.35459,0.0")
    #   #=> [-76.97092, 40.35459, 0.0]
    def extract_coordinates(point)
      Array.new(3).
        replace(point.scan(/-?\d{1,3}\.\d+/)).
        map { |n| n&.to_f }
    end
  end
end
