require 'rails_helper'

RSpec.describe StandingsController, type: [:request] do
  include Devise::Test::IntegrationHelpers

  describe 'the ranked listing of Users' do
    let(:pick) { 'A Team' }
    let!(:user1) { create(:user, current_pick: pick) }
    let!(:user2) { create(:user) }
    let(:user_without_pick) { create(:user, current_pick: nil) }

    describe 'when viewed by a User who is not logged in' do
      it "doesn't show the picks" do
        get '/standings'
        expect(response.body).to_not match(pick)
        expect(response.body).to_not match(user2.current_pick)
      end
    end

    describe 'when viewed by a User who has not made a pick' do
      before { sign_in user_without_pick }

      it "doesn't show the picks" do
        get '/standings'
        expect(response.body).to_not match(pick)
        expect(response.body).to_not match(user2.current_pick)
      end
    end

    describe 'when viewed by a User who has made a pick' do
      before { sign_in user1 }

      it "doesn't show the picks" do
        get '/standings'
        expect(response.body).to match(pick)
        expect(response.body).to match(user2.current_pick)
      end
    end
  end
end
