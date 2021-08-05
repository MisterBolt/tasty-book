Rails.application.routes.draw do
  root "landing_page#index"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :recipes
  resources :cook_books
  resources :recipe_scores, only: :create
end
