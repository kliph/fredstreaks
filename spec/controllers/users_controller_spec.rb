require 'rails_helper'

RSpec.describe UsersController, type: [:request] do
  include Devise::Test::IntegrationHelpers

  def update_user(user, params)
    patch "/users/#{user.id}", params: params
  end

  def make_user_params(params)
    { user: params }
  end

  def update_name(user, name)
    update_user(user, make_user_params({ name: name }))
  end

  def update_team(user, team)
    update_user(user, make_user_params({ team: team }))
  end

  def update_email(user, email)
    update_user(user, make_user_params({ email: email }))
  end

  describe 'User Update' do
    let(:user) { create(:user) }

    before { sign_in user }

    it 'does not update email' do
      old_email = user.email
      update_email(user, 'a_new_email@example.com')
      expect(user.reload.email).to eq(old_email)
    end

    it "updates the user's name" do
      new_name = 'SPC'
      update_name(user, new_name)
      expect(user.reload.name).to eq(new_name)
    end

    it "updates the user's team" do
      new_team = 'South Philly Cat Gang'
      update_team(user, new_team)
      expect(user.reload.team).to eq(new_team)
    end

    it "prevents a user from editing someone else's information" do
      other_user = create(:user)
      expected_name = other_user.name
      update_name(other_user, 'A Name')
      expect(other_user.reload.name).to eq(expected_name)
    end
  end
end
