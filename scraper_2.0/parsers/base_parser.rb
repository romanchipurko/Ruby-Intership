# frozen_string_literal: true

module Parser
  class BaseParser
    def initialize(html, base_url:)
      @doc = Nokogiri::HTML(html)
      @base_url = base_url
    end

    def parse
      raise 'Method not defined'
    end
  end
end
