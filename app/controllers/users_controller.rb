class UsersController < ApplicationController
  SPOTIFY_STATE_KEY = 'spotify_auth_state'.freeze

  def new
    @connected_to_spotify = session[:connected_to_spotify]
    @connected_to_google = session[:connected_to_google]

    # TODO change paths when you change buttons
    if @connected_to_spotify && @connected_to_google
      redirect_to welcome_path
    end
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
    # refactor out if statement and faraday response when spotifywrapper is used
    # need to see if:
    # - I can get email from just initializing the User object
    # - If i can create a custom hash so that I can use persisted refresh/access creds 
    #   - check request.env["omniauth.auth"]
    if service == 'spotify'
      res = Faraday.get('https://api.spotify.com/v1/me') do |req|
        req.headers['Authorization'] = "Bearer #{auth_params['access_token']}"
      end
      user_info = JSON.parse(res.body)

      user = nil
      if logged_in?
        user = current_user
        Rails.logger.debug "currentuseridspotify: #{user.id}"
        user.spotify_email = user_info['email']
      else
        user = User.create(spotify_email: user_info['email'])
      end
      login(user)

      user.assign_attributes(spotify_access: auth_params['access_token'], spotify_refresh: auth_params['refresh_token'])
      user.save
    end
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

      # what if users already exists? spotify already exists?
      find_or_create_user("spotify".freeze, JSON.parse(res.body))
    end

    redirect_to new_user_path
  end

  def login(user)
    Rails.logger.debug "-------------------userid #{user.id}"
    session[:user_id] = user.id
    session[:connected_to_spotify] = user.spotify_email.nil? ? false : true
    session[:connected_to_google] = user.google_email.nil? ? false : true
  end

  def handle_google_callback
    access_token = request.env['omniauth.auth']
    # BUG creates a new user, need to link via session
    user = nil
    if logged_in?
      user = current_user
      Rails.logger.debug "currentuserid google: #{user.id}"
      user.google_email = access_token.info.email
    else
      user = User.create(google_email: access_token.info.email)
    end
    login(user)

    user.google_access = access_token.credentials.token
    # only present the first time user authenticates
    refresh_token = access_token.credentials.refresh_token
    user.google_refresh = refresh_token if refresh_token.present?
    user.save

    redirect_to new_user_path
  end

  def create
  end

  # private

end
