class FixturesController < ApplicationController
  def index
    FixturesService.save_fixture_if_updated!(FixturesService.fetch_fixtures)
    @gameweek_id = Gameweek.last.id
    @fixture = Fixture.find_by(gameweek_id: @gameweek_id)
  end
end
