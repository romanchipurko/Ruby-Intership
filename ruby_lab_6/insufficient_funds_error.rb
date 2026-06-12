# frozen_string_literal: true

class InsufficientFundsError < StandardError
  def message
    'Недостаточно средств на счёте отправителя'
  end
end
