module Cricketer
  class Match
    extend FastAttributes

    attr_reader :match_id, :match_data, :description, :summary, :officials, :innings

    define_attributes initialize: true do
      attribute :match_id, Integer

      attribute :description, String

      attribute :match_data, :summary, OpenStruct

      attribute :team1, :team2, Cricketer::Team
      attribute :innings,   Cricketer::Innings
      attribute :officials, Cricketer::Officials
    end

    def self.create(match_id)
      data = MatchesAPI.new(match_id: match_id).content
      description, summary, innings, official = data.values_at('description', 'match', 'innings', 'official')
      new(match_id: match_id, match_data: data, description: description,
          summary: summary, innings: innings, officials: official)
    end

    # check for live matches
    def self.live_matches
      results = []
      url = 'http://static.cricinfo.com/rss/livescores.xml'
      File.open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          match_id = item.guid.content.split('/').last.split('.').first.to_i
          results << OpenStruct.new(match_id: match_id, description: item.description, url: item.link)
        end
      end
      results
    end

    def teams_data
      @teams_data ||= extract_teams_data
    end

    def team1
      Team.new(teams_data.first)
    end

    def team2
      Team.new(teams_data.last)
    end

    def extract_teams_data
      keys = %i[name id abbrev]
      [1, 2].map do |n|
        values = ["team#{n}_name", "team#{n}_id", "team#{n}_abbreviation"].map do |m|
          summary.send(m.to_sym)
        end
        Hash[keys.zip(values)]
      end
    end

    def to_s
      description
    end

    def current_status
      match_data.live['status'] || 'not-live'
    end

    def result
      to_boolean summary.result
    end

    def team1_innings
      innings_by_team_id(team1.id)
    end

    def team2_innings
      innings_by_team_id(team2.id)
    end

    def innings_by_team_id(id)
      innings.select { |i| i.batting_team_id == id }
    end

    def cancelled
      to_boolean summary.cancelled_match
    end

    def ground
      summary.ground_name
    end

    def floodlit
      to_boolean summary.floodlit
    end

    def batted_first
      summary.batting_first_team_id == team1.id ? team1 : team2
    end

    def followon
      to_boolean summary.followon
    end

    def winning_team
      [team1, team2].find { |t| t.id == summary.winner_team_id }
    end

    def team1_players
      players_by_team_name(team1.name)
    end

    def team2_players
      players_by_team_name(team2.name)
    end

    def players
      match_data.team
    end

    def players_by_team_name(name)
      players.detect { |t| t['team_name'] == name }['player'].map { |p| Player.new(p) }
    end

    private

    def to_boolean(value)
      value == '1'
    end
  end
end
