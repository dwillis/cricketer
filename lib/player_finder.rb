module Cricketer
  class PlayerFinder
    extend FastAttributes

    attr_reader :player_id, :country, :match_data

    define_attributes initialize: true do
      attribute :player_id, Integer
      attribute :country, String
      attribute :match_data, Array
    end

    def self.create(country, player_id)
      data = PlayersAPI.new(country: country, player_id: player_id).content
      new(player_id: player_id, match_data: data)
    end

    # Class methods to extract specific stats from match data array.

    def full_name
      match_data[match_data.index('Full name') + 1]
    end

    def date_of_birth
      "#{match_data[born_position + 1]} #{match_data[born_position + 2]}"
    end

    def current_age
      match_data[born_position + 5]
    end

    def playing_role
      match_data.select { |stat| stat.start_with?('Playing role') }.join
    end

    def batting_style
      match_data.select { |stat| stat.start_with?('Batting style') }.join
    end

    def bowling_style
      match_data.select { |stat| stat.start_with?('Bowling style') }.join
    end

    def batting_and_fielding_averages
      data = {}
      format = ['ODIs', 'T20Is', 'First-class', 'List A', 'T20s']
      keys = match_data[batting_average_stats_position+1..batting_average_stats_position+14]
      values =
      # p match_data
    end

    def bowling_averages

    end


    private

    def odi_stats
      match_data.select { |stat| stat == 'ODIs' }
    end

    def born_position
      match_data.index('Born')
    end

    def batting_average_stats_position
      match_data.index('Batting and fielding averages')
    end
  end
end

