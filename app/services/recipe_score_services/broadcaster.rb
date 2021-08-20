module RecipeScoreServices
  class Broadcaster
    def initialize(recipe_score)
      @recipe_score = recipe_score
    end

    def notify_about_new_score
      @recipe_score.broadcast_append_to :notifications,
        target: "#{@recipe_score.recipe.user.id}_toast",
        partial: "shared/toast",
        locals: {message: "Your #{@recipe_score.recipe.title} recipe has been scored #{@recipe_score.score} by #{@recipe_score.user.username}"}
    end
  end
end
