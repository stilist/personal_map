# frozen_string_literal: true

require 'icalendar'
require_relative '../to_geojson_point'

module Parser
  class ICS
    def initialize(path:)
      file = ::File.read(::File.expand_path(path))
      file.gsub!(/^SEQ:/, 'SEQUENCE:')

      parsed = ::Icalendar::Calendar.parse(file).
        first.
        events

      @data = to_geojson(parsed)
    rescue ::TypeError
      @data = []
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
      if row.description == row.summary || row.description == 'No notes so far.'
        note = nil
      else
        note = row.description.
          sub("#{row.summary} - ", '')
      end

      name = row.summary.
        sub('@ ', '')

      {
        coordinates: row.geo.push(nil),
        name: name,
        note: note,
        startTime: row.dtstart.to_time.iso8601,
        endTime: row.dtend.to_time.iso8601,
      }.freeze
    end
  end
end
