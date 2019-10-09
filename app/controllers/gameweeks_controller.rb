class GameweeksController < ApplicationController
  def index
    @gameweeks = Gameweek.all.order(week: :desc)
  end

  def show
    @gameweek = Gameweek.find(params[:id])
    @fixture = Fixture.find_by(gameweek: @gameweek)
  end
end
