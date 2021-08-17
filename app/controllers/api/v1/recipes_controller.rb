module Api
  module V1
    class RecipesController < ActionController::API
      include ExceptionHandler

      def show
        recipe = Recipe.find(params[:id])

        ingredients = Ingredient
          .includes(:ingredients_recipes)
          .where("ingredients_recipes.recipe_id = ?", params[:id])
          .pluck(:name, :quantity, :unit)

        render json: {status: "SUCCESS", title: recipe.title, ingredients: ingredients}, status: :ok
      end
    end
  end
end
