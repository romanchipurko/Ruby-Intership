# frozen_string_literal: true

class LogProcessor
  CLEANER = Proc.new do |log, not_used|
    log.strip.gsub(/[[:space:]]+/, ' ').gsub('ошибка', 'ERROR')
  end

  VALIDATOR = -> (log, min_len) do
    return false if log.length < min_len

    true 
  end

  class << self
    def each_log(logs:)
      logs.each do |str|
        yield(str)
      end
    end
  end
end
