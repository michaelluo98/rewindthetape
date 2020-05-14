Rails.application.routes.draw do
  root to: 'sessions#welcome'

  resources :users, only: [:new, :create]

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'welcome', to: 'sessions#welcome'

  get 'connect/spotify', to: 'users#request_spotify_auth'
  get 'connect/spotify/callback', to: 'users#handle_spotify_callback'
  get 'connect', to: 'users#connect'

  get 'auth/google_oauth2/callback', to: 'users#handle_google_callback'
  get 'auth/failure', to: 'users#handle_google_callback'
end
