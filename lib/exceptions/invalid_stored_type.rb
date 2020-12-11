# frozen_string_literal: true

module Matakana
  module Exceptions
    # custom error for invalid stored type
    class InvalidStoredType < StandardError
      def initialize(object, type = String)
        message = "Invalid stored type. Expected #{type}." \
                  " Got #{object.class}"
        super(message)
      end
    end
  end
end
