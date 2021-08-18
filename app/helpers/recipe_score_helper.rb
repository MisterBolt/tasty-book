module RecipeScoreHelper
  def user_recipe_score(user, recipe)
    user_score = recipe.recipe_scores.find_by(user_id: user.id)
    return nil if user_score.nil?
    user_score.score
  end

  def average_stars_count(recipe, filling)
    avg_score = recipe.average_score
    if filling == :full
      avg_score.floor
    elsif filling == :percent
      (avg_score % 1) == 0 ? 0 : 1
    else
      (avg_score % 1) == 0 ? 5 - avg_score.floor : 4 - avg_score.floor
    end
  end

  def user_stars_count(recipe, filling)
    user_score = user_recipe_score(current_user, recipe)
    if filling == :full
      return 0 unless user_score
      user_score
    else
      return 5 unless user_score
      5 - user_score
    end
  end

  def star_fill(filling)
    if filling == :full
      "#c89c4c"
    elsif filling == :percent
      "url(#gradient)"
    else
      "#acb1b7"
    end
  end
end
