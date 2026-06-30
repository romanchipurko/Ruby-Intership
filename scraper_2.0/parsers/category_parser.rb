# frozen_string_literal: true

require 'nokogiri'
require 'uri'
require_relative 'base_parser'

module Parser
  class CategoryParser < BaseParser
    def parse
      @doc.css('a.product-card__link').map { |a| absolute_url(a['href']) }.compact
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

    def task_info(task)
      task.payload[:url]
    end
  end
end
