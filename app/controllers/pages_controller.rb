class PagesController < ApplicationController
  def main
    @rank = user_signed_in? ? User.get_rank(current_user) : nil
  end
end
