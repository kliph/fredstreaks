class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to '/'
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :team)
  end
end
