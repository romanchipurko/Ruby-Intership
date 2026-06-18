# frozen_string_literal: true

require 'httparty'

module Scraper
  class HttpClient
    include HTTParty

    default_timeout 20

    def get(url)
      self.class.get(url)
    end
  end
end
