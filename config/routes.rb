Rails.application.routes.draw do
  root "landing_page#index"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: [:show] do
    get :followings, :followers, on: :member
  end
  resources :profile do
    collection do
      get :index, :recipes, :recipe_drafts, :cook_books, :settings
      patch :update_password, :update_username, :update_avatar
    end
  end
  resources :recipes do
    resources :comments
    patch :update_cook_books, on: :member
    post :filter, to: "filters#index", on: :collection
  end
  resources :cook_books
  resources :recipe_scores, only: :create
  resources :follows, only: [:create, :destroy]

  namespace :api do
    namespace :v1 do
      resources :recipes, only: [:show]
    end
  end
end
