class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :correct_user, only: [:edit, :update]

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def show
    @user = User.includes(results: :gameweek).find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :team)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
end
