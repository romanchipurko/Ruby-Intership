# frozen_string_literal: true

require 'httparty'
require_relative 'manager'
require_relative 'worker_driver'
require_relative 'json_storage'
require_relative 'workers/crawler_worker'
require_relative 'workers/category_parser_worker'
require_relative 'workers/product_parser_worker'
require_relative 'workers/result_worker'

Manager.add_task(queue: :crawling, type: :category, payload: { url: 'https://oz.by/books/topic11.html' })

drivers = [
  WorkerDriver.new(queue: :crawling, worker_class: CrawlerWorker, threads_count: 7, client: HTTParty),
  WorkerDriver.new(queue: :category_parsing, worker_class: CategoryParserWorker, threads_count: 2),
  WorkerDriver.new(queue: :product_parsing, worker_class: ProductParserWorker, threads_count: 5),
  WorkerDriver.new(queue: :saving, worker_class: ResultWorker, threads_count: 1, storage: JsonStorage.new(file_path: 'scraper_results.json'))
]

drivers.each(&:start)
sleep
