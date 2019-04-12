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
      format_averages(batting_average_stats_position, bowling_average_position)
    end

    def bowling_averages
      format_averages(bowling_average_position, career_statistics_position)
    end

    private

    def format_averages(start_position, end_position)
      data = {'ODIs' => 0, 'T20Is' => 0, 'First-class' => 0, 'List A' => 0, 'T20s' => 0 }
      averages_column_names = match_data[start_position + 1..start_position + 14]
      averages = match_data[start_position..end_position - 1]
      data.each { |key, value| data[key] = averages.index(key) }

      data.each do |key, value|
        data[key] = Hash[averages_column_names.zip(averages[value + 1..value + 14])]
      end
      data
    end

    def odi_stats
      match_data.find_index { |stat| stat == 'ODIs' }
    end

    def born_position
      match_data.index('Born')
    end

    def batting_average_stats_position
      match_data.index('Batting and fielding averages')
    end

    def bowling_average_position
      match_data.index('Bowling averages')
    end

    def career_statistics_position
      match_data.index('Career statistics')
    end
  end
end

