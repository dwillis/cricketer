require 'open-uri'
require 'ostruct'
require 'json'
require 'fast_attributes'
require 'rss'
require 'nokogiri'

# Require Cricketer::Team before type coercions due to load order limits
require_relative 'team'

# Create Models for Coercions
Cricketer::Inning     = Class.new(OpenStruct)
Cricketer::Official   = Class.new(OpenStruct)
Cricketer::Player     = Class.new(OpenStruct)

Cricketer::Innings    = Class.new(Array)
Cricketer::Officials  = Class.new(Array)

# Define type coercions
# args = (Klass, 'Klass.new(%s)') where %s will be the object
FastAttributes.set_type_casting(OpenStruct, 'OpenStruct.new(%s)')
FastAttributes.set_type_casting(Cricketer::Team, 'Cricketer::Team.new(%s)')
FastAttributes.set_type_casting(Cricketer::Innings, '%s.map { |s| Cricketer::Inning.new(s)}')
FastAttributes.set_type_casting(Cricketer::Officials, '%s.map { |s| Cricketer::Official.new(s)}')

# Must be required after type coercion definitions
require_relative 'version'
require_relative 'match'
require_relative 'matches_api'
require_relative 'world_cup'
require_relative 'player_finder'
require_relative 'players_api'

module Cricketer
end
