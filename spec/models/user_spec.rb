require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#standings' do
    let!(:user_third_place) { create(:user, points: 1) }
    let!(:user_second_place) { create(:user, points: 2) }
    let!(:user_first_place) { create(:user, points: 3) }

    it 'returns the users in order by points' do
      expect(User.standings.pluck(:id)).to eq([user_first_place.id, user_second_place.id, user_third_place.id])
    end

    it 'includes the result of the postgres rank function as an attribute' do
      expect(User.standings.pluck(:rank)).to eq([1, 2, 3])
    end
  end
end
