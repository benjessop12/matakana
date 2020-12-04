# frozen_string_literal: true

module Matakana
  module Functions
    # extended presentation functions
    module Presenter
      def get_keys(options = {})
        return sort unless options[:quickly] == true

        storage.keys(&:to_sym)
      end

      def sort
        storage.keys&.sort
      end
    end
  end
end
