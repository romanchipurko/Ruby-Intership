# frozen_string_literal: true

require_relative 'http_client'
require_relative 'services/links_scraper'
require_relative 'services/product_scraper'
require_relative 'services/collector'

module Scraper
  class Application
    PATH = 'scraper_results.json'

    def initialize(url:, threads:)
      @url = url
      @threads = threads
    end

    def call
      client = HttpClient.new
      scrape_links(client)
      scraper_products(client)
      collect_result
    end

    private

    def scrape_links(client)
      @links = Scraper::Service::LinksScraper.new(
        url: @url,
        client: client
      ).call
    end

    def scraper_products(client)
      @products = Scraper::Service::ProductScraper.new(
        links: @links,
        client: client,
        threads: @threads
      ).call
    end

    def collect_result
      Scraper::Service::Collector.new(data: @products, path: PATH).call
    end
  end
end
