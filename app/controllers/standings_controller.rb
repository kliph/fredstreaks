class StandingsController < ApplicationController
  def index
    @ranked_users = current_user&.current_pick? ? User.standings : User.standings_without_current_pick
  end
end
