require 'rails_helper'

RSpec.describe FixturesService do
  describe '#fetch_fixtures' do
    it 'fetches data from the API' do
      expect(FixturesService.fetch_fixtures).to eq({})
    end
  end
end
