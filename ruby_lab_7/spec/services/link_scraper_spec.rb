# frozen_string_literal: true

require 'spec_helper'
require_relative '../../scraper/http_client'
require_relative '../../scraper/services/links_scraper'

RSpec.describe Scraper::Service::LinksScraper do
  let(:category_url) { 'https://example.com/category' }
  let(:html) { File.read(File.join(__dir__, '../fixtures/category_page.html')) }

  describe '#call' do
    let(:client) { Scraper::HttpClient.new }
    let(:links) { described_class.new(url: category_url, client: client).call }

    before { stub_request(:get, category_url).to_return(status: 200, body: html) }

    it 'returns correct number of unique links' do
      expect(links.size).to eq(2)
    end

    it 'returns normalized absolute product links' do
      expect(links).to eq(
        [
          'https://example.com/product-1',
          'https://example.com/product-2'
        ]
      )
    end
  end
end
