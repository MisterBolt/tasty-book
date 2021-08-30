# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :set_user, except: %i[index recipes recipe_drafts cook_books]
  before_action :authenticate_user!

  def index
    @statistics = User::Dashboard.new(current_user)
  end

  def recipes
    @pagy, @recipes = pagy(current_user.recipes.published, items: per_page)
  end

  def recipe_drafts
    @pagy, @recipes = pagy(current_user.recipes.drafted, items: per_page)
  end

  def cook_books
    @cook_book = CookBook.new
    @visibilities = CookBook.visibilities_strings
    @pagy, @cook_books = pagy(current_user.cook_books, items: per_page)
  end

  def settings
    @minimum_password_length = User.password_length.min
  end

  def update_password
    update_action(@user.update_with_password(user_password_params) && bypass_sign_in(@user))
  end

  def update_username
    update_action(@user.update(user_username_params))
  end

  def update_avatar
    update_action(@user.update(user_avatar_params))
  end

  def delete_user_with_data
    @user.destroy
    flash[:notice] = t(".notice")
    redirect_to root_path
  end

  def delete_user_and_keep_data
    @user.anonymize
    flash[:notice] = t(".notice")
    redirect_to root_path
  end

  private

  def set_user
    @user = current_user
  end

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def user_username_params
    params.require(:user).permit(:username)
  end

  def user_avatar_params
    params.require(:user).permit(:avatar)
  end

  def update_action(condition)
    if condition
      flash[:notice] = t(".notice")
    elsif @user.errors.any?
      flash[:alert] = @user.errors.full_messages.join(", ")
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(settings_profile_index_path)
  end
end
