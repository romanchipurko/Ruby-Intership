# frozen_string_literal: true

require 'colorize'
require_relative 'user'
require_relative 'bank'

while(true)
  puts "\nМеню:"
  puts 'Чтобы создать аккаунт введите 1'
  puts 'Чтобы совершить перевод на другой аккаунт введите 2'
  puts "Чтобы проверить баланс аккаунта введите 3"
  puts 'Чтобы выйти введите 0'

  puts 'Ваш выбор: '
  input = gets.chomp.to_i
  case input
  when 1
    puts 'Введите баланс: '
    balance = gets.chomp

    puts 'Введите имя аккаунта: '
    name = gets.chomp

    if User.find_by(name: name)
      puts 'Пользователь уже существует'.colorize(:red)
    else 
      User.new(name: name, balance: balance)
      puts "Пользователь #{name} с балансом #{balance} успешно создан"
    end

  when 2
    puts 'Введите ваше имя: '
    from_account = gets.chomp

    puts 'Перевод на (введите имя): '
    to_account = gets.chomp

    begin
      print "Введите сумму перевода: "
      amount = gets.chomp
      Bank.transfer(from_account: from_account, to_account: to_account, amount: amount)
      puts 'Перевод успешно выполнен'

    rescue InvalidAmountError, InsufficientFundsError => e
      puts e.message.colorize(:red)
      puts 'Попробуйте ещё раз'
      retry
    rescue => e
      puts "Ошибка: #{e.message}".colorize(:red)
    ensure
      from_acc = User.find_by(name: from_account)
      to_acc = User.find_by(name: to_account)
      if from_acc && to_acc
        puts "Баланс отправителя (#{from_account}): #{from_acc.balance}"
        puts "Баланс получателя (#{to_account}): #{to_acc.balance}"
      elsif from_acc
        puts "Баланс отправителя (#{from_account}): #{from_acc.balance}"
        puts "Счёт получателя '#{to_account}' не найден"
      elsif to_acc
        puts "Счёт отправителя '#{from_account}' не найден"
        puts "Баланс получателя (#{to_account}): #{to_acc.balance}"
      else
        puts 'Оба счёта не найдены'
      end
    end

  when 3
    puts 'Введите имя аккаунта: '
    name = gets.chomp

    if (acc = User.find_by(name: name))
      puts "Баланс счёта '#{name}': #{acc.balance}"
    else
      puts "Аккаунт с именем #{name} не найден".colorize(:red)
    end

  when 0
    puts 'До встречи!'
    break
  end
end
