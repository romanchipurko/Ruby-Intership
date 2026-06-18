# frozen_string_literal: true

require 'nokogiri'

module Scraper
  module Parser
    class ProductParser
      def initialize(html, base_url:)
        @doc = Nokogiri::HTML(html)
        @base_url = base_url
      end

      def parse_product
        {
          link: @base_url,
          title: text_from(selector: 'h1'),
          price: normalize_price(text_from(selector: 'span.b-product-control__text_main')),
          description: text_from(selector: 'div.b-description__sub'),
          availability: text_from(selector: 'div.b-product-control__sub_mover span.b-product-control__text')
        }
      end

      private

      def text_from(selector:)
        @doc.at_css(selector)&.text&.strip
      end

      def normalize_price(price)
        return if price.nil?

        price.match(/\d+,\d+/)&.[](0)&.tr(',', '.')&.to_f
      end
    end
  end
end
