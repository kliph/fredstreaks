class GameweeksController < ApplicationController
  def index
    @gameweeks = Gameweek.all.order(id: :desc)
  end
end
