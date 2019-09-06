class FixturesController < ApplicationController
  def index
    @gameweek_id = Gameweek.last.id
    fixtures = FixturesService.fetch_fixtures(@gameweek_id)
    FixturesService.save_fixture_if_updated!(fixtures)
    @fixture = Fixture.find_by(gameweek_id: @gameweek_id)
  end
end
