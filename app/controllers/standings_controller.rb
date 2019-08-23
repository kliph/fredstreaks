class StandingsController < ApplicationController
  def index
    @users = User.all
  end
end
