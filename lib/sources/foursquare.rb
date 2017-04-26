# frozen_string_literal: true

require_relative '../parsers/ics'

class Foursquare
  def initialize(root:, type:)
    filename = ::Dir.glob("#{root}/*.ics").
      last

    @data = ::Parser::ICS.new(path: filename).
      geojson
  end

  def geojson
    @data
  end
end
