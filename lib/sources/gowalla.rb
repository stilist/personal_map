# frozen_string_literal: true

require 'json'

class Gowalla
  def initialize(root:, type:)
    raw = ::File.read("#{root}/gowalla.json")
    processed = process_data(raw)

    @data = raw
  rescue ::Errno::ENOENT
    @data = []
  end

  def geojson
    @data
  end

  private

  def process_data(data)
    json = JSON.parse(data)

    json['features'].map do |row|
      properties = row['properties']

      {
        coordinates: row.dig('geometry', 'coordinates').push(nil),
        name: properties.dig('place', 'name'),
        note: properties.dig('place', 'note'),
        endTime: properties['endTime'] + 'Z',
        startTime: properties['startTime'] + 'Z',
      }.freeze
    end
  end
end
