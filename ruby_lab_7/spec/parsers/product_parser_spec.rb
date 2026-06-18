# frozen_string_literal: true

require 'spec_helper'
require_relative '../../scraper/parsers/product_parser'

RSpec.describe Scraper::Parser::ProductParser do
  let(:html) { File.read(File.join(__dir__, '../fixtures/product_page.html')) }
  let(:base_url) { 'https://example.com/products/123' }

  describe '#parse_product' do
    subject(:parsed_product) { described_class.new(html, base_url: base_url).parse_product }

    it 'extracts title, price, description and availability from HTML' do
      expect(parsed_product).to include(
        link: base_url,
        title: 'Богатый Папа, Бедный Папа',
        price: 30.1,
        description: 'Возможно, крутая книга',
        availability: 'В наличии'
      )
    end

    it 'converts price to Float' do
      expect(parsed_product[:price]).to be_a(Float)
    end

    it 'converts price correctly' do
      expect(parsed_product[:price]).to eq(30.1)
    end
  end
end
