require 'rails_helper'

RSpec.describe UsersController, type: [:request] do
  include Devise::Test::IntegrationHelpers

  describe 'User Update' do
    let(:user) { create(:user) }

    before { sign_in user }

    it 'does not update email' do
      old_email = user.email
      form_params = {
        user: {
          email: 'foo@example.com'
        }
      }

      patch "/users/#{user.id}", params: form_params
      expect(user.reload.email).to eq(old_email)
    end

    it "updates the user's name" do
      new_name = 'SPC'
      form_params = {
        user: {
          name: new_name
        }
      }

      patch "/users/#{user.id}", params: form_params
      expect(user.reload.name).to eq(new_name)
    end

    it "updates the user's team" do
      new_team = 'South Philly Cat Gang'
      form_params = {
        user: {
          team: new_team
        }
      }

      patch "/users/#{user.id}", params: form_params
      expect(user.reload.team).to eq(new_team)
    end

    it "prevents a user from editing someone else's information" do
      other_user = create(:user)
      expected_name = other_user.name

      form_params = {
        user: {
          name: 'Foob'
        }
      }

      patch "/users/#{other_user.id}", params: form_params
      expect(other_user.reload.name).to eq(expected_name)
    end
  end
end
