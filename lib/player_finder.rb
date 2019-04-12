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
      match_data[position_of('Full name') + 1]
    end

    def date_of_birth
      "#{match_data[position_of('Born') + 1]} #{match_data[position_of('Born') + 2]}"
    end

    def current_age
      match_data[position_of('Born') + 5]
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
      format_averages(position_of('Batting and fielding averages'), position_of('Bowling averages'), 14)
    end

    def bowling_averages
      format_averages(position_of('Bowling averages'), position_of('Career statistics'), 13)
    end

    private

    def format_averages(start_position, end_position, number_of_columns)
      data = {'ODIs' => 0, 'T20Is' => 0, 'First-class' => 0, 'List A' => 0, 'T20s' => 0 }
      averages_column_names = match_data[start_position + 1..start_position + number_of_columns]
      averages = match_data[start_position..end_position - 1]
      data.each { |key, value| data[key] = averages.index(key) }

      data.each do |key, value|
        data[key] = Hash[averages_column_names.zip(averages[value + 1..value + 14])]
      end
      data
    end

    def position_of(value)
      match_data.index(value)
    end
  end
end

