class UsersController < ApplicationController
  SPOTIFY_STATE_KEY = 'spotify_auth_state'.freeze

  def new
    @connected_to_spotify = session[:connected_to_spotify]
    @connected_to_google = session[:connected_to_google]

    # if @connected_to_spotify && @connected_to_google
    #   redirect_to users_landing
  end

  # assumes that there is a current_user
  def refresh_spotify(refresh_token)
    body = {
      grant_type: 'refresh_token',
      refresh_token: current_user.spotify_refresh,
      client_id: Rails.application.credentials.spotify_client_id,
      client_secret: Rails.application.credentials.spotify_client_secret
    }
    res = Faraday.post('https://accounts.spotify.com/api/token') { |req| req.body = body }

    auth_params = JSON.parse(res.body)
    Rails.logger.debug "refresh auth_params: #{auth_params}"
  end

  def find_or_create_user(service, auth_params)
    if service == 'spotify'
      res = Faraday.get('https://api.spotify.com/v1/me') do |req|
        req.headers['Authorization'] = "Bearer #{auth_params['access_token']}"
      end
      user_info = JSON.parse(res.body)

      user = User.find_or_create_by(spotify_email: user_info['email'])
      user.update(spotify_access: user_info['access_token'], spotify_refresh: user_info['refresh_token'])

      session[:user_id] = user.id
      session[:connected_to_spotify] = true
    end

    session[:connected_to_google] = false
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
      client_id: Rails.application.credentials.spotify_client_id,
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
        client_id: Rails.application.credentials.spotify_client_id,
        client_secret: Rails.application.credentials.spotify_client_secret
      }
      res = Faraday.post(url) { |req| req.body = body }

      find_or_create_user("spotify".freeze, JSON.parse(res.body))
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
