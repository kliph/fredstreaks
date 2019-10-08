require 'rails_helper'

RSpec.describe FixturesService do
  let!(:fixture) { create :fixture, updated_at: Time.current - 1.day }

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
      expect(fixture.reload.updated_at.to_i).to eq(last_updated_at.to_i)
    end

    it 'updates the fixture when the fixture is updated' do
      last_updated_at = fixture.updated_at
      FixturesService.save_fixture_if_updated!(postponed_matches)
      expect(fixture.reload.updated_at.to_i).not_to eq(last_updated_at.to_i)
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

    it 'returns false when it receives and empty array' do
      expect(FixturesService.all_finished?([])).to be false
    end
  end

  describe '#score_finished_gameweek!' do
    let(:winning_pick) { 'Arsenal FC' }
    let!(:user) { create :user, current_pick: winning_pick }
    let(:losing_pick) { 'Norwich City FC' }
    let!(:user_with_losing_pick) { create :user, current_pick: losing_pick }
    let(:date) { Date.parse(matches.last.fetch('utc_date')) }
    let(:gameweek) { create :gameweek }

    it 'creates a new result' do
      expect { FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: date) }.to change { Result.count }.by(1)
    end

    describe 'with a winning pick' do
      it "updates the User's score" do
        expect { FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: date) }.to change { user.points }.by(1)
      end

      it "updates the User's current streak" do
        expect { FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: date) }.to change { user.current_streak }.by(1)
      end

      it "resets the User's current pick" do
        FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: date)
        expect(user.reload.current_pick).to be_nil
      end

      it 'creates a Result with the proper data' do
        FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: date)
        result = Result.find_by(date: date, user: user, gameweek: gameweek)
        expect(result.points).to eq 1
        expect(result.pick).to eq winning_pick
      end
    end

    describe 'with a losing pick' do
      it "updates the User's score" do
        expect { FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user_with_losing_pick, date: date) }.to change { user_with_losing_pick.points }.by(0)
      end

      it "updates the User's current streak" do
        expect { FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user_with_losing_pick, date: date) }.to change { user_with_losing_pick.current_streak }.by(0)
      end

      it "resets the User's current pick" do
        FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user_with_losing_pick, date: date)
        expect(user_with_losing_pick.reload.current_pick).to be_nil
      end

      it 'creates a Result with the proper data' do
        FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user_with_losing_pick, date: date)
        result = Result.find_by(date: date, user: user_with_losing_pick, gameweek: gameweek)
        expect(result.points).to eq 0
        expect(result.pick).to eq losing_pick
      end
    end
  end

  describe '#increment_current_gameweek!' do
    let!(:gameweek) { create :gameweek, week: 99 }
    it 'increments the gameweek' do
      expect { FixturesService.increment_gameweek!(gameweek) }.to change { Gameweek.count }.by(1)
      expect(Gameweek.last.week).to eq(100)
    end
  end

  describe '#score_all_picks_and_increment_gameweek!' do
    let!(:user) { create :user }
    let(:matches) { create(:fixture).matches }
    let(:gameweek) { create :gameweek }
    let(:date) { Date.parse(matches.last.fetch('utc_date')) }
    let(:params) do
      {
        matches: matches,
        gameweek: gameweek
      }
    end

    it 'calls score_finished_gameweek! with the appropriate data' do
      allow(FixturesService).to receive(:score_finished_gameweek!)
      FixturesService.score_all_picks_and_increment_gameweek!(params)
      expect(FixturesService).to have_received(:score_finished_gameweek!)
    end

    it 'calls increment_gameweek!' do
      allow(FixturesService).to receive(:increment_gameweek!)
      FixturesService.score_all_picks_and_increment_gameweek!(params)
      expect(FixturesService).to have_received(:increment_gameweek!)
    end
  end
end
