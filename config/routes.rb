Rails.application.routes.draw do
  root "recipes#index"
  devise_for :users
  resources :recipes
  resources :cook_books
  resources :recipe_scores, only: :create
end
