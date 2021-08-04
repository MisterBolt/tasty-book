module RecipeScoreHelper
  def average_recipe_score(recipe)
    recipe.recipe_scores.average(:score).to_f
  end

  def user_recipe_score(user, recipe)
    user_score = recipe.recipe_scores.find_by(user_id: user.id)
    return nil if user_score.nil?
    user_score.score
  end

  def stars_count(recipe, filling)
    avg_score = average_recipe_score(recipe)
    if filling == :full 
      avg_score.floor
    elsif filling == :percent
      (avg_score % 1) == 0 ? 0 : 1
    else 
      (avg_score % 1) == 0 ? 5 - avg_score.floor : 4 - avg_score.floor
    end
  end

  def star_fill(filling)
    if filling == :full
      "#fbbf24"
    elsif filling == :percent
      "url(#gradient)"
    else
      "#acb1b7"
    end
  end
end
