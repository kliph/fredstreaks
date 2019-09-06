require 'rails_helper'

RSpec.describe FixturesController, type: :controller do
  describe '#index', vcr: { record: :new_episodes } do
    let!(:gameweek) { create :gameweek }

    it 'fetches the fixtures' do
      allow(FixturesService).to receive(:fetch_fixtures).and_return([])
      get :index
      expect(FixturesService).to have_received(:fetch_fixtures)
    end

    it 'saves the fixtures' do
      allow(FixturesService).to receive(:save_fixture_if_updated!)
      get :index
      expect(FixturesService).to have_received(:save_fixture_if_updated!)
    end
  end
end
