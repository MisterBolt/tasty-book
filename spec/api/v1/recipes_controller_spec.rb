require "rails_helper"

RSpec.describe RecipesController, type: :request do
  describe "api/v1/recipes:id" do
    context "with valid params" do
      let(:user) { create(:user) }
      let(:recipe) { create(:recipe, user: user) }
      let(:ingredients_recipe) { recipe.ingredients_recipes.first }

      it "should return json containing recipe ingredients data with status:'SUCCESS'" do
        get "/api/v1/recipes/#{recipe.id}"
        json = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)

        expect(json["data"]).to contain_exactly(
          ["ingredients",
            [{
              "name" => ingredients_recipe.ingredient.name,
              "quantity" => ingredients_recipe.quantity,
              "unit" => ingredients_recipe.unit
            }]],
          ["title", recipe.title.to_s]
        )
        expect(json["status"]).to eq(200)
        expect(json["type"]).to eq("Success")
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
