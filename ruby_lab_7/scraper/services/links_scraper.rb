# frozen_string_literal: true

require_relative '../parsers/category_parser'

module Scraper
  module Service
    class LinksScraper
      def initialize(url:, client:)
        @url = url
        @client = client
        @all_links = []
      end

      def call
        scrape_links(current_url: @url)
        @all_links.uniq
      end

      private

      def scrape_links(current_url:)
        loop do
          break unless (response = @client.get(current_url)).success?

          parser = Scraper::Parser::CategoryParser.new(response.body, base_url: current_url)
          @all_links.concat(parser.product_link)

          next_page = parser.next_page_url
          break if next_page.nil? || next_page.empty?

          current_url = next_page
        end
      end
    end
  end
end
