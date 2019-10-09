class GameweeksController < ApplicationController
  def index
    @gameweeks = Gameweek.all.order(week: :desc)
  end
end
