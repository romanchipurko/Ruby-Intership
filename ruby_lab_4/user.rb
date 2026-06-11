# frozen_string_literal: true

require_relative 'database_record'

class User < DatabaseRecord
end

user = User.new
user.setup_attributes({id: 1, name: 'Roma', email: 'somemail@mail.com'})

puts user.id
puts user.name
puts user.email

user.name = 'Alice'
puts user.name
user.find_by_name('Roma')
