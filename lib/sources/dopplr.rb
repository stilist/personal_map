# frozen_string_literal: true

require_relative '../parsers/ics'

class Dopplr
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
