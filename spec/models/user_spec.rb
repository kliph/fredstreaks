require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user_third_place) { create(:user, points: 1) }
  let!(:user_second_place) { create(:user, points: 2) }
  let!(:user_first_place) { create(:user, points: 3) }

  describe '#standings' do
    it 'returns the users in order by points' do
      expect(User.standings.pluck(:id)).to eq([user_first_place.id, user_second_place.id, user_third_place.id])
    end

    it 'includes the result of the postgres rank function as an attribute' do
      expect(User.standings.pluck(:rank)).to eq([1, 2, 3])
    end
  end

  describe '#get_rank' do
    it 'returns the rank of the desired user' do
      expect(User.get_rank(user_first_place)).to eq 1
      expect(User.get_rank(user_third_place)).to eq 3
    end
  end
end
