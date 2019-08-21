class ApplicationController < ActionController::Base
  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to root_path, notice: 'You must log in to view this page.'
    end
  end
end
