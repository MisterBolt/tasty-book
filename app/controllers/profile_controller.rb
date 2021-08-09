class ProfileController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @statistics = {
      followers: current_user.followings.length
    }
  end

  def recipes
  end

  def recipes_draft
  end

  def cook_books
  end

  def settings
  end
end
  