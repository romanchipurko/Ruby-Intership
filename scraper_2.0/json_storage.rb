# frozen_string_literal: true

require 'json'

class JsonStorage
  def initialize(file_path:)
    @file_path = file_path
    @mutex = Mutex.new
  end

  def save(product)
    @mutex.synchronize do
      data = read_file
      data << product
      File.write(@file_path, JSON.pretty_generate(data))
    end
  end

  private

  def read_file
    return [] unless File.exist?(@file_path)

    JSON.parse(File.read(@file_path))
  rescue JSON::ParserError
    []
  end
end
