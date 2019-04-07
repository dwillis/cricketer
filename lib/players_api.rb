module Cricketer
  class PlayersAPI
    extend FastAttributes

    URL_BASE = 'http://www.espncricinfo.com'.freeze

    define_attributes initialize: true, attributes: true do
      attribute :player_id, Integer
      attribute :country, String
    end

    def url
      "#{URL_BASE}/#{country}/content/player/#{player_id}.html"
    end

    def content
      doc = Nokogiri::HTML(open(url))
      doc.css('script, link').map(&:remove)
      @content = doc.css('body').text.squeeze(" \n")
    end
  end
end
