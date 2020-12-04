# frozen_string_literal: false

Dir.glob('./lib/**/*.rb').sort.each do |file|
  require file
end

# Entry point for the gem
module Matakana
  extend self
end
