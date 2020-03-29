# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'matakana/version'

Gem::Specification.new do |spec|
  spec.name = 'opito'
  spec.version = Matakana::VERSION
  spec.authors = ['Ben Jessop']
  spec.date = '2020-03-29'
  spec.summary = 'Fun utility gem for basic hash functions'
  spec.files = 'git ls-files'.split($/)
  spec.require_paths = ['lib']

  spec.add_dependency 'facets'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
