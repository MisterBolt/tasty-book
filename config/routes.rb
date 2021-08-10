Rails.application.routes.draw do
  root "landing_page#index"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: [:show] do
    get :followings, :followers, on: :member
  end
  resources :profile do
    collection { get :index, :recipes, :recipe_drafts, :cook_books, :settings }
  end
  resources :recipes do
    resources :comments
    patch :update_cook_books, on: :member
  end
  resources :cook_books
  resources :recipe_scores, only: :create
  resources :follows, only: [:create, :destroy]
end
