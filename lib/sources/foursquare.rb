# frozen_string_literal: true

require_relative '../parsers/kml'

class Foursquare
  def initialize(root:, type:)
    filename = ::Dir.glob("#{root}/*.kml").
      last

    @data = ::Parser::KML.new(path: filename, type: :point).
      data
  end

  def geojson
    @data
  end
end
