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
    it 'fetches data from the API', vcr: { record: :new_episodes } do
      expect(FixturesService.fetch_fixtures(1)).to eq(matches)
    end
  end

  describe '#save_fixture_if_updated!' do
    describe 'with a new gameweek' do
      it 'creates the fixture if there is not one already in the database' do
        gameweek = create :gameweek
        FixturesService.save_fixture_if_updated!(matches)
        expect(Fixture.last.gameweek).to eq gameweek
        expect(Fixture.last.matches).to eq matches
      end
    end

    it 'does not update the fixture when the fixture is not updated' do
      last_updated_at = fixture.updated_at
      FixturesService.save_fixture_if_updated!(matches)
      expect(fixture.reload.updated_at).to eq last_updated_at
    end

    it 'updates the fixture when the fixture is updated' do
      last_updated_at = fixture.updated_at
      FixturesService.save_fixture_if_updated!(postponed_matches)
      expect(fixture.reload.updated_at).not_to eq last_updated_at
    end
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
