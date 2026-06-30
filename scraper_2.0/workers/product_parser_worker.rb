# frozen_string_literal: true

require_relative 'base_worker'
require_relative '../parsers/product_parser'

class ProductParserWorker < BaseWorker
  def process(task)
    Parser::ProductParser.new(task.payload[:html], base_url: task.payload[:url]).parse
  end

  def post_process(task, result)
    return if result.nil?

    log(task, "parsed product: #{result[:title]}")
    Manager.add_task(queue: :saving, type: :product, payload: { product: result })
    super
  end

  private

  def task_info(task)
    task.payload[:status]
  end
end
