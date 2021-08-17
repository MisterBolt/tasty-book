require "rails_helper"

RSpec.describe RecipesController, type: :request do
  describe "api/v1/recipes:id" do
    context "with valid params" do
      let(:user) { create(:user) }
      let(:ingredient) { create(:ingredient) }
      let(:recipe) { create(:recipe, user: user) }
      let!(:ingredients_recipe) { create(:ingredients_recipe, recipe: recipe, ingredient: ingredient) }

      it "should return json containing recipe ingredients data with status:'SUCCESS'" do
        get "/api/v1/recipes/#{recipe.id}"
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json["status"]).to eq("SUCCESS")
        expect(json["title"]).to eq(recipe.title)
        expect(json["ingredients"]).to contain_exactly(
          [ingredient.name,
            ingredients_recipe.quantity,
            ingredients_recipe.unit]
        )
      end
    end

    context "with unknown recipe's id" do
      it "should return json with status:'NOT_FOUND'" do
        get "/api/v1/recipes/0"
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json["status"]).to eq("NOT_FOUND")
        expect(json["message"]).to eq("Couldn't find Recipe with 'id'=0")
      end
    end
  end
end
