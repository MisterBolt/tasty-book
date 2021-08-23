module RecipeScoreServices
  class Broadcaster
    def initialize(recipe_score)
      @recipe_score = recipe_score
    end

    def notify_about_new_score
      @recipe_score.broadcast_append_to :notifications,
        target: "#{@recipe_score.recipe.user.id}_toast",
        partial: "shared/toast",
        locals: {message: I18n.t("notifications.recipe_score", recipe: @recipe_score.recipe.title, score: @recipe_score.score, user: @recipe_score.user.username)}
    end
  end
end
