Rails.application.routes.draw do
  root 'pages#main'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'auth/:provider/callback', to: 'sessions#google_auth'
  get 'auth/failure', to: redirect('/')
  resources :users, only: [:edit, :show, :update]
  resources :gameweeks, only: [:index]
  get 'standings', to: 'standings#index'
end
