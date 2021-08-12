# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @statistics = {
      followers: current_user.followers.count,
      following: current_user.followings.count,
      user_comments: current_user.comments.count,
      comments_for_user: Comment.where(recipe: current_user.recipes).count,
      user_recipes_in_cook_books: current_user.recipes.joins(:cook_books).distinct.count,
      recipes: current_user.recipes.count,
      # TODO: user's drafts of recipes instead of 0
      recipe_drafts: 0,
      recipes_average_score: helpers.average_recipes_score(current_user.recipes),
      cook_books: current_user.cook_books.count
    }
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
