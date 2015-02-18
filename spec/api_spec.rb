require 'spec_helper'

RSpec.describe Cricketer::API do
  subject { Cricketer::API }
  let(:match_id) { 656399 }

  let(:api) do
    VCR.use_cassette("match_#{match_id}") do
      subject.new(match_id: match_id)
    end
  end

  context 'produces valid url' do

    it 'matches the url' do
      expect(api.url).to eq "http://www.espncricinfo.com/matches/engine/match/#{match_id}.json"
    end
  end
end
