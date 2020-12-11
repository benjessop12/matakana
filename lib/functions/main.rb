# frozen_string_literal: true

require_relative '../helpers/utils'
require_relative '../functions/presenter'
require_relative '../functions/search'

module Matakana
  module Functions
    # logic that allows user to interact with data store
    class Main
      include ::Matakana::Helpers::Utils
      include ::Matakana::Functions::Presenter
      include ::Matakana::Functions::Search

      attr_accessor :storage

      def initialize
        @storage = @storage ||= @storage = {}
      end

      def save(key, value = nil)
        return if value.nil?

        check_key key
        data = block_given? ? yield : value
        storage[key.to_sym] << data
      end

      def bulk_save(arr, split_count = 5)
        raise ::Matakana::Exceptions::InvalidStoredType.new(arr, 'Array') \
              unless arr.is_a? Array

        batch = arr.size / split_count
        split_count.times.map do |t|
          idx = batch * t
          instance_variable_set("@thread_#{t}", Thread.new do
            inner_processing arr, idx, batch
          end)
          instance_variable_get("@thread_#{t}").join
        end
      end

      def bulk_save_dup_key(arr, split_count = 5)
        bulk_save(merge_arr(arr), split_count)
      end

      private

      def inner_processing(arr, idx, batch)
        batch.times do |x|
          Mutex.new.synchronize do
            val = arr[idx + x]
            save(val.keys[0], extract_values(val.values))
          end
        end
      end
    end
  end
end
