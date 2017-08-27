# frozen_string_literal: true

require 'nokogiri'
require_relative '../to_geojson_path'

module Parser
  class KML
    def initialize(path:)
      file = ::File.open(::File.expand_path(path))

      document = ::Nokogiri::XML(file)
      segments = document.css('Folder')
      parsed = segments.map { |segment| to_geojson(segment) }.
        flatten.
        compact

      @data = ::ToGeojsonPath.new(data: parsed).
        data
    end

    attr_reader :data

    def geojson
      @data.geojson
    end

    private

    def to_geojson(segment)
      coordinates = segment.css('LineString > coordinates')
      return if coordinates.empty?

      name = segment.css('> name').text
      # If `name` has a space it's Google Maps' default 'Directions from…'
      # label.
      activity = name =~ /\s/ ? nil : name

      points = coordinates.text.split(' ')
      {
        coordinates: [points.map { |point| row_for_geojson(point) }].freeze,
        properties: {
          activity: activity,
        }.freeze,
      }.freeze
    end

    def row_for_geojson(point)
      coordinate = /-?\d{1,3}\.\d+/
      pattern = /(?<lon>#{coordinate}),(?<lat>#{coordinate}),(?<alt>#{coordinate})/
      matches = point.match(pattern)

      [matches[:lon].to_f, matches[:lat].to_f, matches[:alt]&.to_f].freeze
    end
  end
end
