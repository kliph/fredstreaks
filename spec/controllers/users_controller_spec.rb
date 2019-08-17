require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'User Edit' do
    xit 'assings @user' do
      user = User.create
      user.save
      get edit_user_path(user)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'User Update' do
    it 'does not update email'
    it "updates the user's name"
    it "updates the user's team name"
  end
end
