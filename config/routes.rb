Rails.application.routes.draw do
  resources :home, only: [:index]
  root to: "home#index"
  resources :users do
    collection  do
      post :create
      patch :update
      delete :destroy
    end
  end
  resources :error, only: [:index]
  resources :user_sign_in, only: [:create]
end
