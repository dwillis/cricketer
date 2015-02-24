require 'spec_helper'

RSpec.describe Cricketer::WorldCup do
  subject { Cricketer::WorldCup }

  let(:points_table) do
    VCR.use_cassette("points_table") do
      subject.points_table
    end
  end

  context 'produces valid data' do

    it 'describes the first team in the first pool by name' do
      expect(points_table[0][0][:name]).to eq 'New Zealand'
    end
  end

end
