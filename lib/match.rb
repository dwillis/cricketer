module Cricketer
  class Match

    attr_reader :match_id, :json_url, :match_data, :description, :summary, :innings, :officials, :team1, :team2,
      :team1_players, :team2_players, :current_status, :innings, :team1_innings, :team2_innings, :ground,
      :floodlit, :batted_first, :winning_team, :cancelled, :result

    def initialize(match_id)
      @match_id = match_id
      @json_url = "http://www.espncricinfo.com/matches/engine/match/#{match_id}.json"
      @match_data = JSON.parse(open(@json_url).read)
      @description = @match_data['description']
      @summary = OpenStruct.new(@match_data['match'])
      @team1 = OpenStruct.new(name: @summary.team1_name, id: @summary.team1_id, abbrev: @summary.team1_abbreviation)
      @team2 = OpenStruct.new(name: @summary.team2_name, id: @summary.team2_id, abbrev: @summary.team2_abbreviation)
      @innings = @match_data['innings'].map{|i| OpenStruct.new(i)}
      @officials = @match_data['official'].map{|o| OpenStruct.new(o)}
    end

    def to_s
      @description
    end

    def current_status
      @match_data['live']['status']
    end

    def innings
      @match_data['innings'].map{|i| OpenStruct.new(i)}
    end

    def result
      @summary.result == "1" ? true : false
    end

    def team1_innings
      innings.select{|i| i.batting_team_id == @team1.id}
    end

    def cancelled
      @summary.cancelled_match == 'N' ? false : true
    end

    def ground
      @summary.ground_name
    end

    def floodlit
      @summary.floodlit == "1" ? true : false
    end

    def batted_first
      @summary.batting_first_team_id == @team1.id ? @team1 : @team2
    end

    def followon
      @summary.followon == "1" ? true : false
    end

    def winning_team
      if @match_data['match']['winner_team_id'] == @team1.id
        @team1
      elsif @match_data['match']['winner_team_id'] == @team2.id
        @team2
      else
        nil
      end
    end

    def team1_players
      @match_data['team'].detect{|t| t['team_name'] == @team1.name}['player'].map{|p| OpenStruct.new(p)}
    end

    def team2_players
      @match_data['team'].detect{|t| t['team_name'] == @team2.name}['player'].map{|p| OpenStruct.new(p)}
    end

  end
end
