class UsersController < ApplicationController
  def new
  end

  def create
		# TODO going to need to check if they signed up with spotify/gcal

		# @user = User.create(params.require(:user).permit(:username, :password))
		# session[:user_id] = @user.id
		# redirect_to '/welcome'
  end
end
