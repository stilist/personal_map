#!/usr/bin/env ruby

# frozen_string_literal: true

require 'active_support/inflector'
require 'fileutils'
require_relative 'lib/merge_geojson'

DATA_ROOT = ::File.expand_path(ENV.fetch('HISTORY_DATA_PATH'))

raise "Source data path doesn't exist (#{ENV['HISTORY_DATA_PATH']})" if !File.directory?(DATA_ROOT)
OUTPUT_ROOT = ::File.expand_path('tmp')
::Dir.mkdir(OUTPUT_ROOT) if !::File.exists?(OUTPUT_ROOT)

::ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.uncountable(%w(gyroscope_places moves openpaths photos))
end

source_types = {
  path: %i(flightaware google gpx gyroscope moves openpaths),
  point: %i(dopplr facebook foursquare google gowalla gpx gyroscope moves photos reporter),
}

source_types.each do |source_type, sources|
  sources.each do |source|
    require_relative "lib/sources/#{source}"

    klass = source.to_s.
      classify.
      constantize
    parsed = klass.new(root: DATA_ROOT, type: source_type).
      geojson

    out_path = ::File.join(OUTPUT_ROOT, "#{source}_#{source_type}.json")
    ::File.open(out_path, 'w') { |f| f.write(parsed) }
  end

  output_file = "all_#{source_type}s.json"
  source_files = sources.map { |source| "#{source}_#{source_type}" }
  ::MergeGeojson.new(root: OUTPUT_ROOT, filename: output_file, sources: source_files)

  ::FileUtils.cp("#{OUTPUT_ROOT}/#{output_file}",
               "public/#{source_type}_data.json")
end
