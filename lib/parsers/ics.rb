# frozen_string_literal: true

require 'icalendar'
require_relative '../to_geojson_point'

module Parser
  class ICS
    def initialize(path:)
      file = ::File.open(::File.expand_path(path))

      parsed = ::Icalendar::Calendar.parse(file).
        first.
        events

      @data = to_geojson(parsed)
    end

    def geojson
      @data
    end

    private

    def to_geojson(data)
      prepared = data.map { |row| row_for_geojson(row) }

      ::ToGeojsonPoint.new(data: prepared).
        geojson
    end

    def row_for_geojson(row)
      if row.description == row.summary
        note = ''
      else
        note = row.description.
          sub("#{row.summary} - ", '')
      end

      name = row.summary.
        sub('@ ', '')

      {
        name: name,
        note: note,
        lat: row.geo[0],
        lng: row.geo[1],
        timestamp: row.dtstart
      }.freeze
    end
  end
end
