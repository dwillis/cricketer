module Cricketer
  class Team
    extend FastAttributes

    define_attributes initialize: true, attributes: true do
      attribute :name, :id, :abbrev, String
      attribute :team_no, Integer
    end
  end
end
