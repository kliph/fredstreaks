require 'rails_helper'

RSpec.describe FixturesController, type: :controller do
  describe '#index', vcr: { record: :new_episodes } do
    let!(:gameweek) { create :gameweek }
    let!(:user) { create :user }
    let(:fixture) { create :fixture }

    let(:unfinished_matches) do
      new_matches = fixture.matches.clone
      new_matches[0] = fixture.matches[0].merge('status' => 'SCHEDULED')
      new_matches
    end

    describe 'with finished matches' do
      before :each do
        allow(FixturesService).to receive(:fetch_fixtures).and_return(fixture.matches)
      end

      it 'fetches the fixtures' do
        get :index
        expect(FixturesService).to have_received(:fetch_fixtures)
      end

      it 'saves the fixtures' do
        allow(FixturesService).to receive(:save_fixture_if_updated!)
        get :index
        expect(FixturesService).to have_received(:save_fixture_if_updated!)
      end

      it 'scores the gameweek' do
        allow(FixturesService).to receive(:score_finished_gameweek!)
        get :index
        expect(FixturesService).to have_received(:score_finished_gameweek!)
      end

      it 'increments the gameweek' do
        allow(FixturesService).to receive(:increment_gameweek!)
        get :index
        expect(FixturesService).to have_received(:increment_gameweek!)
      end
    end

    describe 'with unfinished matches' do
      before :each do
        allow(FixturesService).to receive(:fetch_fixtures).and_return(unfinished_matches)
      end

      it "doesn't score the gameweek" do
        allow(FixturesService).to receive(:score_finished_gameweek!)
        get :index
        expect(FixturesService).not_to have_received(:score_finished_gameweek!)
      end

      it "doesn't increment the gameweek" do
        allow(FixturesService).to receive(:increment_gameweek!)
        get :index
        expect(FixturesService).not_to have_received(:increment_gameweek!)
        expect(Gameweek.last.week).to eq(gameweek.week)
      end
    end
  end
end
