# frozen_string_literal: true

file_path = ARGV[0]
string = File.read(file_path).strip

stack = []
string.each_char do |el|
  stack.last == el ? stack.pop : stack.push(el)
end

puts stack.join
