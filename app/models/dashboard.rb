class Dashboard
  include RecipeScoreHelper

  def initialize(user)
    @user = user
  end

  def followers
    @user.followers.count
  end

  def following
    @user.followings.count
  end

  def user_comments
    @user.comments.count
  end

  def comments_for_user
    Comment.where(recipe: @user.recipes).count
  end

  def user_recipes_in_cook_books
    @user.recipes.joins(:cook_books).distinct.count
  end

  def recipes
    @user.recipes.count
  end

  # TODO: user's drafts of recipes instead of 0
  def recipe_drafts
    0
  end

  def recipes_average_score
    average_recipes_score(@user.recipes)
  end

  def cook_books
    @user.cook_books.count
  end
end
