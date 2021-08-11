module Api
  class RecipesController < ApplicationController
    def show
      recipe = Recipe.find(params[:id])

      sql = "SELECT I.name
                  , Ir.quantity
                  , Ir.unit
             FROM Ingredients I
             JOIN  Ingredients_recipes Ir
             ON I.id = Ir.ingredient_id
             WHERE Ir.recipe_id = #{params[:id]}"

      ingredients = ActiveRecord::Base.connection.execute(sql).to_a
      ingredients.each do |ingredient|
        ingredient["unit"] = IngredientsRecipe.units.key(ingredient["unit"])
      end

      render json: {status: "SUCCESS", title: recipe.title, ingredients: ingredients}, status: :ok
    end
  end
end
