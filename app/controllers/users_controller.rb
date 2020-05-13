class UsersController < ApplicationController
  SPOTIFY_STATE_KEY = 'spotify_auth_state'.freeze

  def new
    @user_has_spotify = session[:user_has_spotify]
    @user_has_google = session[:user_has_google]
    # if @user_has_spotify && @user_has_google
    #   redirect_to users_landing

    Rails.logger.debug "in new------------------------"
    Rails.logger.debug "userspotify: #{@user_has_spotify}"
    Rails.logger.debug "usergoogle: #{@user_has_google}"
  end

  def set_user_state(tokens)
    # call the api and see if you are calling via spotify/google?
    # see fi user exists... if not, make one
    Rails.logger.debug "set_user_state"
    session[:user_has_spotify] = true
    session[:user_has_google] = true
  end

  def request_spotify_auth
    Rails.logger.debug "requesting spotify auth ---------------------------------"
    Rails.logger.debug "params: #{params}"

    scope = 'user-read-email user-read-recently-played'
    authorize_base_url = 'https://accounts.spotify.com/authorize'
    state = SecureRandom.base36
    session[SPOTIFY_STATE_KEY] = state
    request_query = {
      response_type: 'code',
      client_id: "#{Rails.application.credentials.spotify_client_id}",
      scope: scope,
      redirect_uri: 'http://localhost:3000/connect/spotify/callback',
      state: state.to_s
    }

    redirect_to "#{authorize_base_url}?#{request_query.to_query}"
  end

  # TODO handle failure: redirect to users page with flash error message?
  def handle_spotify_callback
    if params[:error]
      Rails.logger.warn "Spotify authorization failed: #{params[:error]}"
    elsif params[:state] != session[SPOTIFY_STATE_KEY]
      Rails.logger.warn "Spotify authorization failed beacuse state param values don't match"
    else
      session.delete(SPOTIFY_STATE_KEY)
      url = 'https://accounts.spotify.com/api/token'
      body = {
        grant_type: 'authorization_code',
        code: params[:code],
        redirect_uri: 'http://localhost:3000/connect/spotify/callback',
        client_id: "#{Rails.application.credentials.spotify_client_id}",
        client_secret: "#{Rails.application.credentials.spotify_client_secret}"
      }

      res = Faraday.post(url) { |req| req.body = body }
      Rails.logger.debug "res.status: #{res.status}"
      Rails.logger.debug "res.body: #{res.body}"
      set_user_state res.body
    end


    redirect_to new_user_path
  end

  def create
    # TODO going to need to check if they signed up with spotify/gcal
    # note that params is not empty
    # @user = User.create(params.require(:user).permit(:username, :password))
    # session[:user_id] = @user.id
    # redirect_to '/welcome'
  end

  # private

end
