require 'rails_helper'

RSpec.describe StandingsController, type: [:request] do
  include Devise::Test::IntegrationHelpers

  describe 'the ranked listing of Users' do
    let(:pick) { 'A Team' }
    let!(:user1) { create(:user, current_pick: pick) }
    let!(:user2) { create(:user) }

    describe 'when viewed by a User who is not logged in' do
      it "doesn't show the picks" do
        get '/standings'
        expect(response.body).to_not match(pick)
        expect(response.body).to_not match(user2.current_pick)
      end
    end
  end
end
