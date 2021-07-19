class RecipeScoresController < ApplicationController
  before_action :require_user

  def create
    @recipe = Recipe.find_by(id: params[:recipe_score][:recipe_id])
    @recipe_score = current_user.recipe_scores.build(recipe_score_params)

      if @recipe_score.save
        flash[:notice] = t(".notice") 
        redirect_back fallback_location: root_url
      else
        flash[:warning] = t(".warning")
        redirect_back fallback_location: root_url
      end
  end

  private
    def recipe_score_params
      params.require(:recipe_score).permit(:recipe_id, :score)
    end
end
