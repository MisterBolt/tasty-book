module Api
  module V1
    class RecipesController < ActionController::API
      include Api::Concerns::ErrorSerializer

      def show
        recipe = Recipe.find(params[:id])

        render json: {
          data: ActiveModelSerializers::SerializableResource.new(recipe, serializer: RecipeSerializer),
          status: 200,
          type: "Success"
        }
      end
    end
  end
end
