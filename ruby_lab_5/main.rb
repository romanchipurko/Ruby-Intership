# frozen_string_literal: true

require_relative 'log_processor' 

logs = [' some   text', 'error    message', 'ошибка', 'wow!']

LogProcessor.each_log(logs: logs) { |str| puts "#{Time.now} #{str}" }

cleaned_logs = logs.map { |log| LogProcessor::CLEANER.call(log) }
puts cleaned_logs

logs.each do |log|
  unless LogProcessor::VALIDATOR.call(log, 5)
    puts "Строка слишком короткая: #{log}"
  end
end
