class ApplicationController < ActionController::Base
  # # make methods accessible to views
  helper_method :current_user
  # helper_method :logged_in?

  def current_user
    Rails.logger.debug "in current user session user id: #{session[:user_id]}"
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
