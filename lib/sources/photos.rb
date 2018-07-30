# frozen_string_literal: true

require 'json'
require_relative '../to_geojson_point'

class Photos
  def initialize(root:, type:)
    raw = ::File.read("#{root}/metadata.json")
    parsed = ::JSON.parse(raw, symbolize_names: true)
    @data = ::ToGeojsonPoint.new(data: parsed).
      geojson
  rescue ::Errno::ENOENT
    @data = []
  end

  def geojson
    @data
  end
end


# SELECT RKMaster.imagePath AS path,
#        RKMaster.Uuid,
# FROM   RKMaster,
#        RKVersion
# WHERE  RKVersion.masterUuid = RKMaster.Uuid
#        AND RKVersion.latitude IS NOT NULL
