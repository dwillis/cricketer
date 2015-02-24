module Cricketer
  class WorldCup

    def self.points_table
      url = "http://www.espncricinfo.com/wc2007/engine/series/509587.json?view=pointstable"
      points = JSON.parse(open(url).read)
      pool_a = points['graph']["Pool A"].keys.map{|k| {id: k, name: points['graph']["Pool A"][k]['team_name'], matches: points['graph']["Pool A"][k]['points'].size, points: points['graph']["Pool A"][k]['points'].last['points']}}
      pool_b = points['graph']["Pool B"].keys.map{|k| {id: k, name: points['graph']["Pool B"][k]['team_name'], matches: points['graph']["Pool B"][k]['points'].size, points: points['graph']["Pool B"][k]['points'].last['points']}}
      [pool_a.sort_by!{|h| h[:points]}.reverse, pool_b.sort_by!{|h| h[:points]}.reverse]
    end
  end
end
