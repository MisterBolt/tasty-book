# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :set_user, only: [:update_avatar, :update_password, :update_username, :settings]
  before_action :authenticate_user!

  def index
    @statistics = User::Dashboard.new(current_user)
  end

  def recipes
  end

  def recipe_drafts
  end

  def cook_books
  end

  def settings
    @minimum_password_length = User.password_length.min
  end

  def update_password
    if @user.update_with_password(user_password_params)
      bypass_sign_in(@user)
      flash[:notice] = t(".notice")
    elsif @user.errors.any?
      flash[:alert] = @user.errors.full_messages[0]
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(settings_profile_index_path)
  end

  def update_username
    if @user.update(user_username_params)
      flash[:notice] = t(".notice")
    elsif @user.errors.any?
      flash[:alert] = @user.errors.full_messages[0]
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(settings_profile_index_path)
  end

  def update_avatar
    if @user.update(user_avatar_params)
      flash[:notice] = t(".notice")
    elsif @user.errors.any?
      flash[:alert] = @user.errors.full_messages[0]
    else
      flash[:alert] = t(".alert")
    end
    redirect_to(settings_profile_index_path)
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
end
