class StandingsController < ApplicationController
  def index
    @ranked_users = User.standings
  end
end
