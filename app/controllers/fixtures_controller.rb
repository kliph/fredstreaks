class FixturesController < ApplicationController
  def index
    gameweek = Gameweek.last
    @week = gameweek.week
    matches = FixturesService.fetch_fixtures(@week)
    FixturesService.save_fixture_if_updated!(matches)
    @are_all_matches_finished = FixturesService.all_finished?(matches)
    if @are_all_matches_finished
      User.all.each do |user|
        FixturesService.score_finished_gameweek!(matches: matches, gameweek: gameweek, user: user, date: Date.new)
      end
      FixturesService.increment_gameweek!
    end
    @fixture = Fixture.find_by(gameweek: gameweek)
  end
end
