module RecipeScoreHelper
  def average_recipe_score(recipe)
    recipe.recipe_scores.average(:score).to_f
  end

  def user_recipe_score(user, recipe)
    user_score = recipe.recipe_scores.find_by(user_id: user.id)
    return nil if user_score.nil?
    user_score.score
  end
end
