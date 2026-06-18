# frozen_string_literal: true

require 'optparse'
require_relative 'scraper/application'

options = {
  url: nil,
  threads: 1
}

OptionParser.new do |opts|
  opts.banner = 'bundle exec ruby scraper.rb --url <LINK> --threads <N>'

  opts.on('--url URL') do |url|
    options[:url] = url
  end

  opts.on('--threads THREADS', Integer) do |thr|
    options[:threads] = thr
  end
end.parse!

Scraper::Application.new(
  url: options[:url],
  threads: options[:threads]
).call
