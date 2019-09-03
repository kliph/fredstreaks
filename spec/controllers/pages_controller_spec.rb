require 'rails_helper'

RSpec.describe PagesController, type: [:request] do
  include Devise::Test::IntegrationHelpers

  describe '#main' do
    let(:user) { create(:user) }

    describe 'with a signed in User' do
      it "displays the User's rank" do
        sign_in user
        get '/'
        expect(response.body).to match(User.get_rank(user).ordinalize)
      end
    end

    describe 'without a signed in User' do
      it "displays the User's rank" do
        get '/'
        expect(response.body).not_to match(User.get_rank(user).ordinalize)
      end
    end
  end
end
