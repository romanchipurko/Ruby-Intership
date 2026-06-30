# frozen_string_literal: true

require 'securerandom'

class Task
  attr_reader :queue, :payload, :type, :result, :error, :id, :created_at, :completed_at
  attr_accessor :status

  def initialize(queue:, payload:, type:)
    @id = SecureRandom.uuid
    @queue = queue          # :crawling, :caregory_parsing, :product_parsing, :saving
    @payload = payload      # { url: '' }, { html: '' }, { product: {...} }
    @status = :pending      # :running, :completed, :failed
    @result = nil
    @error = nil
    @created_at = Time.now
    @completed_at = nil
    @type = type
  end

  def start!
    @status = :running
  end

  def done!(result = nil)
    @status = :completed
    @result = result
    @completed_at = Time.now
  end

  def fail!(error = nil)
    @status = :failed
    @error = error
    @completed_at = Time.now
  end
end
