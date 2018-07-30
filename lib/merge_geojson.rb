# frozen_string_literal: true

require 'active_support/time'
require 'json'

class MergeGeojson
  def initialize(filename:, root:, sources:)
    output_path = "#{root}/#{filename}"

    data = sources.map { |source| process_file("#{root}/#{source}.json") }.
      flatten(1)
    sorted = data.sort_by do |record|
      timestamp = record.dig('properties', 'startTime')
      next(::Date.jd(0)) if timestamp.nil?

      ::Time.parse(timestamp)
    end
    out = {
      type: 'FeatureCollection',
      features: sorted,
    }.freeze

    ::File.open(output_path, 'w') { |f| f.write(::JSON.pretty_generate(out)) }
  end

  private

  def process_file(path)
    raw = ::File.read(path)
    data = ::JSON.parse(raw)

    data['features']
  rescue TypeError
    []
  end
end
