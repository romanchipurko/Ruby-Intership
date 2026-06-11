# frozen_string_literal: true

require_relative 'auto_attributes'

class DatabaseRecord
  include AutoAttributes

  def method_missing(method_name, *args)
    field = method_name.to_s.delete_prefix('find_by_')
    puts "Поиск в базе по полю #{field} со значением #{args[0]}"
  end
end
