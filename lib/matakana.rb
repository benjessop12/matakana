# frozen_string_literal: false

require_relative 'helpers/asessors.rb'
require_relative 'helpers/utils.rb'
require_relative 'structures/data_store.rb'
require_relative 'models/data_stores.rb'

# Entry point for the gem
module Matakana
  extend self

  include Matakana::Assessors
  include Matakana::Utils
end
