class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :followings, :followers]

  def show
    @pagy, @recipes = pagy(@user.recipes, items: per_page)
  end

  def followings
    @pagy, @followings = pagy(@user.followings, items: per_page)
  end

  def followers
    @pagy, @followers = pagy(@user.followers, items: per_page)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
