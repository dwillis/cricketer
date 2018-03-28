module Cricketer
  class API
    extend FastAttributes

    URL_BASE = 'http://www.espncricinfo.com/matches/engine/match'.freeze

    define_attributes initialize: true, attributes: true do
      attribute :match_id, Integer
    end

    def url
      [URL_BASE, "#{match_id}.json"].join('/')
    end

    def content
      @content ||= JSON.parse(open(url).read)
    end
  end
end
