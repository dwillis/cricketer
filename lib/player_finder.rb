require_relative 'players_api'

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
      p data
      new(player_id: player_id, match_data: [data])
    end
  end
end

        # self.url = "http://www.espncricinfo.com/ci/content/player/{0}.html".format(str(player_id))
        # self.json_url = "http://core.espnuk.org/v2/sports/cricket/athletes/{0}".format(str(player_id))
        # self.parsed_html = self.get_html()
        # self.json = self.get_json()
        # self.player_information = self._parse_player_information()
        # self.cricinfo_id = str(player_id)
