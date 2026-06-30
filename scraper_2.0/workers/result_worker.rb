# frozen_string_literal: true

require_relative 'base_worker'

class ResultWorker < BaseWorker
  def initialize(storage:)
    super
    @storage = storage
  end

  def process(task)
    product = task.payload[:product]
    #log(task, "saving: #{product[:title]}")
    @storage.save(product)
  end

  private

  def task_info(task)
    task.payload[:product][:title]
  end
end
