# frozen_string_literal: true

class ProfileController < ApplicationController
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
  end
end
