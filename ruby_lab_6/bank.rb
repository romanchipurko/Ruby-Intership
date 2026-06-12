# frozen_string_literal: true

require_relative 'user'
require_relative 'insufficient_funds_error'
require_relative 'invalid_amount_error'

class Bank
  def self.transfer(from_account:, to_account:, amount:)
    amount = amount.to_f
    raise InvalidAmountError if amount <= 0

    from_user = User.find_by(name: from_account)
    to_user = User.find_by(name: to_account)

    raise "Отправитель #{from_account} не найден" unless from_user
    raise "Получатель #{to_account} не найден" unless to_user

    raise InsufficientFundsError if from_user.balance < amount

    from_user.balance -= amount
    to_user.balance += amount
  end
end
