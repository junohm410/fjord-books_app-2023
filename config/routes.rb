Rails.application.routes.draw do
  devise_for :users
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:index, :show]

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "books#index"
end
