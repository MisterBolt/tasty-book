require "rails_helper"

RSpec.describe RecipeScoreHelper, type: :helper do
  let(:recipe) { create(:recipe) }
  let(:scorer) { create(:user) }
  let!(:recipe_score) { create(:recipe_score, user_id: scorer.id, recipe_id: recipe.id).score }
  let!(:another_recipe_score) { create(:recipe_score, recipe_id: recipe.id).score }

  describe "#average_recipe_score" do
    it "returns average of recipe scores" do
      expect(average_recipe_score(recipe)).to eq((recipe_score + another_recipe_score) / 2.0)
    end
  end

  describe "#user_recipe_score" do
    it "returns user's score for the recipe" do
      expect(user_recipe_score(scorer, recipe)).to eq(recipe_score)
    end
  end
end
