require 'open-uri'
require 'ostruct'
require 'json'
require 'fast_attributes'
require 'rss'

# Require Cricketer::Team before type coercions due to load order limits
require 'team'

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
require 'version'
require 'match'
require 'api'

module Cricketer

  # check for live matches
  def self.live_matches
    results = []
    url = 'http://static.cricinfo.com/rss/livescores.xml'
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        match_id = item.guid.content.split('/').last.split('.').first.to_i
        results << OpenStruct.new(match_id: match_id, description: item.description, url: item.link)
      end
    end
    results
  end

  def self.worldcup_points
    url = "http://www.espncricinfo.com/wc2007/engine/series/509587.json?view=pointstable"
    points = JSON.parse(open(url).read)
    pool_a = points['graph']["Pool A"].keys.map{|k| {id: k, name: points['graph']["Pool A"][k]['team_name'], matches: points['graph']["Pool A"][k]['points'].size, points: points['graph']["Pool A"][k]['points'].last['points']}}
    pool_b = points['graph']["Pool B"].keys.map{|k| {id: k, name: points['graph']["Pool B"][k]['team_name'], matches: points['graph']["Pool B"][k]['points'].size, points: points['graph']["Pool B"][k]['points'].last['points']}}
    [pool_a.sort_by!{|h| h[:points]}.reverse, pool_b.sort_by!{|h| h[:points]}.reverse]
  end

end
