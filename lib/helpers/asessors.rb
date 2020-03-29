# frozen_string_literal: true

module Matakana
  module Assessors
    extend self

    def self.print_memory_usage
      mem_before = "ps -o rss= -p #{Process.pid}".to_i
      yield
      mem_after = "ps -o rss= -p #{Process.pid}".to_i

      puts "Memory #{((mem_after - mem_before) / 1024.0).round(2)} MB"
    end

    def self.duration
      start_time = Process.clock_gettime(PROCESS::CLOCK_MONOTONIC)
      yield
      Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time
    end

    def self.current_timestamp
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end
