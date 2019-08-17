require 'rails_helper'

RSpec.describe UsersController, type: [:controller, :request] do
  describe 'User Update' do
    let(:user) { create(:user) }

    it 'does not update email' do
      old_email = user.email
      form_params = {user: {
                       email: 'foo@example.com'
                     }}
      patch "/users/#{user.id}", params: form_params
      expect(user.email).to equal(old_email)
    end
    it "updates the user's name"
    it "updates the user's team name"
  end
end
