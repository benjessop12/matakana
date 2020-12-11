# frozen_string_literal: true

module Matakana
  module Functions
    # extended search functions
    module Search
      def fuzzy_search(term)
        found_keys = storage.keys.grep(/#{term}/)
        storage.values_at(*found_keys)
      end

      def find_by(term)
        storage.fetch term.to_sym
      rescue KeyError
        'Term not present'
      end
    end
  end
end
