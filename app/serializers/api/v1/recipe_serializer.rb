module Api::V1
  class RecipeSerializer < ActiveModel::Serializer
    attributes :title, :ingredients

    def ingredients
      object.ingredients_recipes.map do |ingredient_recipe|
        {
          name: ingredient_recipe.ingredient.name,
          quantity: ingredient_recipe.quantity,
          unit: ingredient_recipe.unit
        }
      end
    end
  end
end
