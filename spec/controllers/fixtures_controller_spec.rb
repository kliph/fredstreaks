require 'rails_helper'

RSpec.describe FixturesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let!(:gameweek) { create :gameweek }
  let(:fixture) { create :fixture }
  let(:started_fixture) { create :one_started_fixture }
  let(:unstarted_fixture) { create :unstarted_fixture }

  let(:unfinished_matches) do
    new_matches = fixture.matches.clone
    new_matches[0] = fixture.matches[0].merge('status' => 'SCHEDULED')
    new_matches
  end

  describe '#create' do
    let(:user) { create(:user, current_pick: nil) }
    let(:pick) { 'Manchester United FC' }

    before :each do
      sign_in user
      allow(FixturesService).to receive(:fetch_fixtures).and_return(unstarted_fixture.matches)
    end

    it 'creates the pick' do
      post :create, params: { current_pick: pick }
      expect(user.reload.current_pick).to eq(pick)
    end

    it 'handles submitting without a pick' do
      post :create, params: { current_pick: nil }
      expect(user.reload.current_pick).to be_nil
    end

    it 'returns 403 forbidden if the user already has a pick' do
      user.current_pick = pick
      user.save
      post :create, params: { current_pick: 'Everton FC' }
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 403 forbidden if the fixture is started' do
      allow(FixturesService).to receive(:fetch_fixtures).and_return(started_fixture.matches)
      post :create, params: { current_pick: 'Everton FC' }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe '#index' do
    let!(:user) { create :user }

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
