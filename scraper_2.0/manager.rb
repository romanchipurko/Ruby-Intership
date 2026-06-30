# frozen_string_literal: true

require 'singleton'
require_relative 'task'

class Manager
  include Singleton

  def initialize
    @queues = Hash.new { |h, k| h[k] = Queue.new }
  end

  def self.add_task(task)
    instance.add_task(build_task(task))
  end

  def self.next_task(queue)
    instance.next_task(queue)
  end

  def add_task(task)
    @queues[task.queue] << task
  end

  def next_task(queue)
    @queues[queue].pop(true)
  rescue ThreadError
    nil
  end

  def self.build_task(task)
    return task if task.is_a?(Task)

    Task.new(queue: task.fetch(:queue), type: task.fetch(:type), payload: task.fetch(:payload))
  end
end
