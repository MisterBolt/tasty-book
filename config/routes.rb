Rails.application.routes.draw do
  root "landing_page#index"
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: [:show] do
    get :followings, :followers, on: :member
  end
  resources :profile, only: [:index] do
    collection do
      get :recipes, :recipe_drafts, :cook_books, :settings
      patch :update_password, :update_username, :update_avatar, :delete_user_and_keep_data
      delete :delete_user_with_data
    end
  end
  resources :recipes do
    resources :comments
    patch :update_cook_books, on: :member
    patch :update_favourite, on: :member
  end
  resources :cook_books
  resources :recipe_scores, only: :create
  resources :follows, only: [:create, :destroy]
  resource :admin_panel, only: [:show] do
    collection do
      get :comments
      patch "/comment/:id", action: :comment_approve, as: :comment_approve
      delete "/comment/:id", action: :comment_reject, as: :comment_reject
    end
  end
  namespace :api do
    namespace :v1 do
      resources :recipes, only: [:show]
    end
  end
end
