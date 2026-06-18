# frozen_string_literal: true

require 'nokogiri'
require 'uri'

module Scraper
  module Parser
    class CategoryParser
      def initialize(html, base_url:)
        @doc = Nokogiri::HTML(html)
        @base_url = base_url
      end

      def product_link
        @doc.css('a.product-card__link').map { |a| absolute_url(a['href']) }.compact.uniq
      end

      def next_page_url
        return if (href = @doc.at_css('a.g-pagination__next')&.[]('href')) == '#'

        absolute_url(href)
      end

      private

      def absolute_url(href)
        return if href.nil?

        URI.join(@base_url, href).to_s
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
