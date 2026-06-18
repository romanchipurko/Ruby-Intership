# frozen_string_literal: true

require 'json'

module Scraper
  module Service
    class Collector
      def initialize(data:, path:)
        @data = data
        @path = path
      end

      def call
        File.write(@path, JSON.pretty_generate(@data))
        puts 'Scraping successfully complete'
      end
    end
  end
end
