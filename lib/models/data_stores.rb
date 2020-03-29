# frozen_string_literal: true

module Matakana
  module DataStores
    extend self

    def save(key, value = nil)
      return if value.nil?

      check_key(key)
      data = block_given? ? yield : value
      storage[key.to_sym] << data
    end

    def bulk_save(arr, split_count: 5)
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

    def bulk_save_dup_key(arr, split_count: 5)
      # if the save arr has duplicate keys they will need to be merged together
      bulk_save(arr.merge_arr.to_a, split_count)
    end

    def find_by(term)
      storage.fetch(term.to_sym)
    rescue KeyError
      return nil
    end

    def get_keys(options = {})
      return sort unless options[:quickly] == true
      storage.each_key(&:to_sym)
    end

    private

    # alias method
    def storage
      DataStore.initialize_storage
    end

    def check_key(key)
      if key.is_a?(String) || key.is_a?(Symbol)
        key_exists?(key)
        return
      end
      raise TypeError, 'key must be a String or Symbol'
    end

    def key_exists?(key)
      return if storage.key?(key.to_sym) == true

      storage[key.to_sym] = []
    end

    def splat(key, val)
      # unused
      { key.to_sym => val, **storage }
    end

    def slice(arr)
      # unused
      arr.each_with_object({}) { |k, v| v[k] == storage[k] if storage.key?(k) }
    end

    def merge_arr
      return unless self.is_a?(Array)

      self.flat_map(&:to_a).group_by(&:first).map { |k, v| Hash[k, v.map(&:last)] }
    end

    def sort
      keys = storage.keys.sort
      Hash[keys.zip(storage.values_at(*keys))]
    end

    def value_type(value)
      return value if value.count > 1

      value[0]
    end
  end
end
