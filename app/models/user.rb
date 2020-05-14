class User < ApplicationRecord

  # TODO
  # assumes that only spotify columns are updated
  # may need to add last_spotify_refresh:timestamp column
  def spotify_access_expired?
    # spotify access token expires_in 3600
    (Time.now - self.updated_at) > 3300
  end

  def self.from_omniauth(service, auth)
    if service == "spotify"
      # TODO change auth
      find_or_create_by(spotify_email: auth)
    end
  end
end
