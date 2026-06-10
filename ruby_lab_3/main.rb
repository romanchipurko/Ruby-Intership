# frozen_string_literal: true

require 'benchmark'

def brute_force(nums:, target:)
  nums.each_with_index do |num, i|
    sec = target - num
    j = nums.index(sec)
    if j && j != i
      puts "\nBrute Force"
      puts "Target: #{target}"
      puts "First: #{nums[i]}"
      puts "Second: #{nums[j]}"
      puts "Result: #{[i, j].inspect}"
      break
    end
  end
end

def hash_map(nums:, target:)
  hash = {}
  nums.each_with_index do |num, i|
    sec = target - num
    if hash.key?(sec)
      puts "\nHash Map"
      puts "Target: #{target}"
      puts "First: #{nums[i]}"
      puts "Second: #{sec}"
      puts "Result: #{[i, hash[sec]]}"
      break
    else
      hash[num] = i
    end
  end
end

nums = Array.new(20000) { rand(-100000...100000) }
target = nums[-2] + nums[-1]

time_brute_force = Benchmark.realtime { brute_force(nums: nums, target: target) }
time_hash_map = Benchmark.realtime { hash_map(nums: nums, target: target) }

puts "\nBrute Force time: #{time_brute_force}"
puts "Hash Map time: #{time_hash_map}"
