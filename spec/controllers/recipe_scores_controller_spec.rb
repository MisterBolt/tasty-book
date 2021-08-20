require "rails_helper"

RSpec.describe RecipeScoresController, type: :controller do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:other_recipe) { create(:recipe) }

  describe "POST #create" do
    context "score has been assigned" do
      before do
        sign_in user
        post :create, params: {recipe_score: {recipe_id: recipe.id, score: 5}}
      end
      it "adds recipe score to database" do
        expect do
          post :create, params: {recipe_score: {recipe_id: other_recipe.id, score: 5}}
        end.to change { RecipeScore.count }.by(1)
      end

      it "displays notice flash message" do
        expect(flash[:notice]).to eq(I18n.t(".recipe_scores.create.notice"))
      end

      it "sends new score notification email" do
        expect do
          post :create, params: {recipe_score: {recipe_id: other_recipe.id, score: 5}}
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "redirects to recipe page" do
        expect(response).to redirect_to(recipe_path(recipe.id))
      end
    end

    context "score has not been assigned" do
      before do
        sign_in user
        post :create, params: {recipe_score: {recipe_id: recipe.id, score: nil}}
      end
      it "does not add recipe score to database" do
        expect do
          post :create, params: {recipe_score: {recipe_id: other_recipe.id, score: nil}}
        end.not_to change { RecipeScore.count }
      end

      it "displays warning flash message" do
        expect(flash[:warning]).to eq(I18n.t(".recipe_scores.create.warning"))
      end

      it "redirects to recipe page" do
        expect(response).to redirect_to(recipe_path(recipe.id))
      end
    end
  end
end
