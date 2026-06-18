# frozen_string_literal: true

require_relative '../parsers/product_parser'

module Scraper
  module Service
    class ProductScraper
      def initialize(links:, client:, threads:)
        @links = links
        @client = client
        @threads = threads
        @results = []
        @mutex = Mutex.new
        @queue = Queue.new
      end

      def call
        init_queue
        start_threads.each(&:join)
        @results
      end

      private

      def init_queue
        @links.each { |link| @queue << link }
      end

      def start_threads
        Array.new(@threads) { Thread.new { process_queue } }
      end

      def process_queue
        loop do
          break unless (url = next_url)

          process_product(url)
        end
      end

      def next_url
        @queue.pop(true)
      rescue ThreadError
        nil
      end

      def process_product(url)
        return unless (response = @client.get(url))&.success?

        save_product(response.body, url)
      end

      def save_product(html, url)
        product = Scraper::Parser::ProductParser.new(html, base_url: url).parse_product
        @mutex.synchronize { @results << product }
      end
    end
  end
end
