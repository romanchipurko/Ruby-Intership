# frozen_string_literal: true

require_relative 'base_worker'

class CrawlerWorker < BaseWorker
  def initialize(client:)
    super
    @client = client
  end

  def process(task)
    url = task.payload[:url]
    #log(task, "GET #{url}")
    return if url.nil?

    response = @client.get(url)
    raise "HTTP #{response.code} #{url}" unless response.success?

    {
      url: url,
      html: response.body
    }
  end

  def post_process(task, result)
    return if result.nil?

    Manager.add_task(queue: define_queue(task), type: task.type, payload: result)
    super
  end

  private

  def define_queue(task)
    case task.type
    when :category
      :category_parsing
    when :product
      :product_parsing
    else
      raise "Unknown task type: #{task.type}"
    end
  end

  def task_info(task)
    task.payload[:status]
  end
end
