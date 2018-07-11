Rails.application.routes.draw do
  resources :home, only: [:index]
  root to: "home#index"
  resources :users, only: %i(create)
  resources :error, only: [:index]
  resources :user_sign_in, only: [:create]
end
