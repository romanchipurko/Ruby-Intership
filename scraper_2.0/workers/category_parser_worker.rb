# frozen_string_literal: true

require_relative 'base_worker'
require_relative '../parsers/category_parser'

class CategoryParserWorker < BaseWorker
  def process(task)
    parser = Parser::CategoryParser.new(task.payload[:html], base_url: task.payload[:url])

    {
      links: parser.parse,
      next_page: parser.next_page_url
    }
  end

  def post_process(task, result)
    log(task, "#{result[:links].size} products found")

    result[:links].each do |link|
      next if link.nil?

      Manager.add_task(queue: :crawling, type: :product, payload: { url: link })
    end

    next_page = result[:next_page]
    return if next_page.nil?

    Manager.add_task(queue: :crawling, type: :category, payload: { url: next_page })
    super
  end

  private

  def task_info(task)
    task.payload[:url]
  end
end
