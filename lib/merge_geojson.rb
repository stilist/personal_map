# frozen_string_literal: true

require 'json'

class MergeGeojson
  def initialize(filename:, root:, sources:)
    output_path = "#{root}/#{filename}"

    data = sources.map { |source| process_file("#{root}/#{source}.json") }.
      flatten(1)
    out = {
      type: 'FeatureCollection',
      features: data,
    }.freeze

    ::File.open(output_path, 'w') { |f| f.write(::JSON.generate(out)) }
  end

  private

  def process_file(path)
    raw = ::File.read(path)
    data = ::JSON.parse(raw)

    data['features']
  end
end
