# frozen_string_literal: true

require_relative '../parsers/ics'
require_relative '../to_geojson_point'

class Dopplr
  def initialize(root:, type:)
    filename = ::Dir.glob("#{root}/partial exports/dopplr/*.ics").
      last

    points = ::Parser::ICS.new(path: filename).
      data
    @data = ::ToGeojsonPoint.new(data: points).
      geojson
  end

  def geojson
    @data
  end
end
