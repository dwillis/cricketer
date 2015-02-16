module Cricketer
  class Match

    def initialize(match_id)
      @match_id = match_id
      @json_url = "http://www.espncricinfo.com/matches/engine/match/#{match_id}.json"
      @match_data = JSON.parse(open(@json_url).read)
      @description = OpenStruct.new(@match_data['description'])
      @summary = OpenStruct.new(@match_data['match'])
      @innings = OpenStruct.new(@match_data['innings'])
      @officials = OpenStruct.new(@match_data['official'])
      @teams = OpenStruct.new(@match_data['team'])
    end

  end
end
