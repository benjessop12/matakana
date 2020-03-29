# frozen_string_literal: true

module Matakana
  # base logic for the data store
  class DataStore
    attr_accessor :mem_storage

    def initialize
      @mem_storage = @mem_storage ||= @mem_storage = {}
    end
  end
end
