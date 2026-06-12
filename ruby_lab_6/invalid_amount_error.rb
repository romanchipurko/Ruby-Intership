# frozen_string_literal: true

class InvalidAmountError < StandardError
  def message
    'Сумма перевода должна быть положительной'
  end
end
