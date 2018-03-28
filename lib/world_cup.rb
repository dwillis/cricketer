module Cricketer
  class WorldCup
    def self.points_table
      url = 'http://www.espncricinfo.com/wc2007/engine/series/509587.json?view=pointstable'
      points = JSON.parse(open(url).read)
      pool_a = get_graph_pool(points, 'Pool A')
      pool_b = get_graph_pool(points, 'Pool B')
      [pool_a.sort_by! { |h| h[:points] }.reverse, pool_b.sort_by! { |h| h[:points] }.reverse]
    end

    private_class_method

    def self.get_graph_pool(points, name)
      pool = points['graph'][name]
      pool.keys.map do |k|
        {
          id: k,
          name: pool[k]['team_name'],
          matches: pool[k]['points'].size,
          points: pool[k]['points'].last['points']
        }
      end
    end
  end
end
