require 'date'
require "simplecov"
SimpleCov.start

require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
# Add simplecov

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative '../lib/administrator'
require_relative '../lib/reservation'
require_relative '../lib/room'
require_relative '../lib/invalid_duration_error'
require_relative '../lib/room_not_available_error'
