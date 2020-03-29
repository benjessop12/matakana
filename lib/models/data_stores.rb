# frozen_string_literal: true

require_relative '../helpers/utils.rb'

module Matakana
  # logic that allows user to interact with data store
  class DataStores
    include Matakana::Utils

    attr_accessor :storage

    def initialize
      @storage = @storage ||= Matakana::DataStore.new.mem_storage
    end

    def save(key, value = nil)
      return if value.nil?

      check_key(key)
      data = block_given? ? yield : value
      storage[key.to_sym] << data
    end

    def bulk_save(arr, split_count = 5)
      return nil unless arr.is_a?(Array)

      batch = arr.size / split_count
      split_count.times.map do |t|
        idx = batch * t
        instance_variable_set("@thread_#{t}", Thread.new do
          batch.times do |x|
            Mutex.new.synchronize do
              val = arr[idx + x]
              save(val.keys[0], value_type(val.values))
            end
          end
        end)
        instance_variable_get("@thread_#{t}").join
      end
    end

    def bulk_save_dup_key(arr, split_count = 5)
      # if the save arr has duplicate keys they will need to be merged together
      bulk_save(arr.merge_arr.to_a, split_count)
    end

    def find_by(term)
      storage.fetch(term.to_sym)
    rescue KeyError
      nil
    end

    def get_keys(options = {})
      return sort unless options[:quickly] == true

      storage.keys(&:to_sym)
    end
  end
end
