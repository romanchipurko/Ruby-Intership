# frozen_string_literal: true

class User
  attr_accessor :balance, :name

  @@all = []

  def initialize(name:, balance:)
    @balance = balance.to_f
    @name = name
    @@all << self
  end

  def self.find_by(name:)
    @@all.find { |user| user.name == name}
  end

  def self.all
    @all
  end
end
