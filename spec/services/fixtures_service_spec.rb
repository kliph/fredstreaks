require 'rails_helper'

RSpec.describe FixturesService do
  let!(:fixture) { create :fixture }

  let(:matches) { fixture.matches }

  let(:postponed_matches) do
    new_matches = matches.clone
    new_matches[0] = matches[0].merge('status' => 'POSTPONED')
    new_matches
  end

  let(:unfinished_matches) do
    new_matches = matches.clone
    new_matches[0] = matches[0].merge('status' => 'SCHEDULED')
    new_matches
  end

  describe '#fetch_fixtures' do
    it 'fetches data from the API', :vcr do
      expect(FixturesService.fetch_fixtures).to eq(matches)
    end
  end

  describe '#save_fixtures!' do
    it 'does not update the fixture when the fixture is not updated'

    it 'updates the fixture when the fixture is updated'
  end

  describe '#all_finished?' do
    it 'returns true when all fixtures are in finished-like states' do
      expect(FixturesService.all_finished?(matches)).to be true
      expect(FixturesService.all_finished?(postponed_matches)).to be true
    end

    it 'returns false when all fixtures are not finished' do
      expect(FixturesService.all_finished?(unfinished_matches)).to be false
    end
  end
end
