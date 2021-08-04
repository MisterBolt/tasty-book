class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @title = t(".title")
    @user = User.find(params[:id])
    @pagy, @recources = pagy(@user.recipes, items: per_page)
    @not_found_message = t("recipes.not_found")
  end

  def followings
    @title = t(".title")
    @user = User.find(params[:id])
    @pagy, @recources = pagy(@user.followings, items: per_page)
    @not_found_message = t(".not_found")
    render "show"
  end

  def followers
    @title = t(".title")
    @user = User.find(params[:id])
    @pagy, @recources = pagy(@user.followers, items: per_page)
    @not_found_message = t(".not_found")
    render "show"
  end
end
