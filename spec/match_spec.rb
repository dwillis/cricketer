require 'spec_helper'

RSpec.describe Cricketer::Match do
  subject { Cricketer::Match }
  let(:match_id) { 656_399 }

  let(:match) do
    VCR.use_cassette("match_#{match_id}") do
      subject.create match_id
    end
  end

  context 'produces valid data' do
    it 'describes the match with #to_s' do
      expect(match.to_s).to eq 'ICC Cricket World Cup, 1st Match, Pool A: '\
                                'New Zealand v Sri Lanka at Christchurch, Feb 14, 2015'
    end

    it 'returns the current status' do
      expect(match.current_status).to eq 'New Zealand won by 98 runs'
    end

    it 'returns team data' do
      expect(match.team1.name).to eq 'New Zealand'
    end
  end
end
