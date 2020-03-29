# frozen_string_literal: true

module Matakana
  # utility methods for gems
  module Utils
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

    def merge_arr
      return unless self.is_a?(Array)

      self.flat_map(&:to_a)
        .group_by(&:first)
        .map { |k, v| Hash[k, v.map(&:last)] }
    end

    def sort
      storage.keys.sort
    end

    def value_type(value)
      return value if value.count > 1

      value[0]
    end
  end
end
