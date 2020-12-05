# frozen_string_literal: true

module Matakana
  module Helpers
    # utility methods for gems
    module Utils
      def check_key(key)
        return store_key_if_absent(key) \
          if key.is_a?(String) || key.is_a?(Symbol)

        raise TypeError.new 'key must be a String or Symbol'
      end

      def store_key_if_absent(key)
        return if storage.key?(key.to_sym) == true

        storage[key.to_sym] = []
      end

      def merge_arr(array)
        return unless array.is_a? Array

        array.flat_map(&:to_a)
             .group_by(&:first)
             .map { |k, v| Hash[k, v.map(&:last)] }
             .to_a
      end

      def extract_values(values)
        return values if values.count > 1

        values.first
      end
    end
  end
end
