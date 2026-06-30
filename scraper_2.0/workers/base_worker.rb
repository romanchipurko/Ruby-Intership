# frozen_string_literal: true

class BaseWorker
  def initialize(**_opts); end

  def call(task:)
    pre_process(task)
    result = process(task)
    post_process(task, result)
  rescue StandardError => e
    task.fail!(e)
    handle_error(e, task)
  end

  private

  def pre_process(task)
    task.start!
  end

  def process(task)
    raise NotImplementedError
  end

  def post_process(task, result)
    task.done!(result)
  end

  def handle_error(err, task)
    warn "Task #{task.id} failed: #{err.message}"
  end

  def log(task, message)
    puts "[#{self.class.name}] #{message} #{task_info(task)}"
  end

  def task_info(task); end
end
