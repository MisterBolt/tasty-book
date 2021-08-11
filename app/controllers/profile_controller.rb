# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!

  def index
    @statistics = {
      followers: current_user.followers.length,
      following: current_user.followings.length,
      user_comments: current_user.comments.length,
      comments_for_user: (current_user.recipes.map do |recipe|
        recipe.comments.length
      end).sum,
      user_recipes_in_cook_books: (current_user.recipes.map do |recipe|
        recipe.cook_books.length
      end).sum,
      recipes: current_user.recipes.length,
      # TODO: user's drafts of recipes instead of 0
      recipe_drafts: 0,
      recipes_average_score: helpers.average_recipes_score(current_user.recipes),
      cook_books: current_user.cook_books.length
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
