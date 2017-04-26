# frozen_string_literal: true

require 'json'

class Gowalla
  def initialize(root:, type:)
    raw = ::File.read("#{root}/gowalla.json")
    @data = raw
  end

  def geojson
    @data
  end
end
