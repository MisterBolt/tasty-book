module ProfileHelper
  def dashboard_widths(recipes, recipe_drafts, recipes_average_score)
    recipes_width = 0
    recipe_drafts_width = 0
    score_width = 0
    score_complement_width = 0

    if(recipes + recipe_drafts) > 0
      recipes_width = recipes.to_f / (recipes + recipe_drafts) * 100
      recipe_drafts_width = recipe_drafts.to_f / (recipes + recipe_drafts) * 100
    end

    if(recipes_average_score) > 0
      score_width = recipes_average_score / 5 * 100
      score_complement_width = (5 - recipes_average_score) / 5 * 100
    end

    {
      recipes: recipes_width,
      recipe_drafts: recipe_drafts_width,
      score: score_width,
      score_complement: score_complement_width
    }
  end

  def dashboard_bar_text(width, text)
    width > 15 ? text : ""
  end
end
