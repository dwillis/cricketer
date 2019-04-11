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
      format_indicies = {'ODIs' => 0, 'T20Is' => 0, 'First-class' => 0, 'List A' => 0, 'T20s' => 0 }
      batting_averages = match_data[batting_average_stats_position..bowling_average_position - 1]
      format_indicies.each { |key, value| format_indicies[key] = batting_averages.index(key) }

      column_names = match_data[batting_average_stats_position + 1..batting_average_stats_position + 14]

      format_indicies.each do |key, value|
        format_indicies[key] = Hash[column_names.zip(batting_averages[value + 1..value + 14])]
      end

      p format_indicies

      # batting_data = {}
      # formats.each do |format|
      #   batting_data[format]
      # end
      # Hash[*keys.zip(instruments).flatten]
      # p match_data
    end

    def bowling_averages

    end


    private

    def position(name)
      match_data.index(name)
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
  end
end

