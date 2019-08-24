class GameweeksController < ApplicationController
  def index
    @gameweeks = Gameweek.all
  end
end
