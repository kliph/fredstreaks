class FixturesController < ApplicationController
  def index
    gameweek = Gameweek.last
    @week = gameweek.week
    matches = FixturesService.fetch_fixtures(@week)
    FixturesService.save_fixture_if_updated!(matches)
    @are_all_matches_finished = FixturesService.all_finished?(matches)
    FixturesService.score_all_picks_and_increment_gameweek!(matches: matches, gameweek: gameweek) if @are_all_matches_finished
    @fixture = Fixture.find_by(gameweek: gameweek)
  end
end
