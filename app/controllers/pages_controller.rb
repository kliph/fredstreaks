class PagesController < ApplicationController
  def main
    @rank = User.get_rank(current_user)
  end
end
