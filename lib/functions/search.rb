# frozen_string_literal: true

module Matakana
  module Functions
    # extended search functions
    module Search
      def fuzzy_search(term)
      end

      def find_by(term)
        storage.fetch term.to_sym
      rescue KeyError
        nil
      end
    end
  end
end
