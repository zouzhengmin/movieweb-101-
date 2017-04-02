Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies do
    resources :comments
    member do
      post :join
      post :quit
    end
  end

  namespace :account do
    resources :movies
    resources :comments
  end


    resources :comments
  root 'movies#index'
end
