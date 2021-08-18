require "rails_helper"

RSpec.describe ProfileController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    def get_index_action
      get :index
    end
    context "when user isn't signed in" do
      before { get_index_action }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    context "when user has default statistics" do
      before do
        sign_in user
        get_index_action
      end
      let(:statistics) { assigns(:statistics) }

      it { expect(statistics.followers).to eq(0) }
      it { expect(statistics.following).to eq(0) }
      it { expect(statistics.user_comments).to eq(0) }
      it { expect(statistics.comments_for_user).to eq(0) }
      it { expect(statistics.user_recipes_in_cook_books).to eq(0) }
      it { expect(statistics.recipes).to eq(0) }
      it { expect(statistics.recipe_drafts).to eq(0) }
      it { expect(statistics.recipes_average_score).to eq(0) }
      it { expect(statistics.cook_books).to eq(1) }
    end

    context "when user increases his statistics" do
      before do
        sign_in user
        create_list(:follow, 3, followed_user: user)
        create(:follow, follower: user)
        create(:comment, user: user)
        recipe = create(:recipe, user: user)
        other_recipe = create(:recipe, user: user)
        create(:comment, recipe: recipe)
        create(:recipe_score, recipe: recipe, score: 4)
        create(:recipe_score, recipe: other_recipe, score: 2)
        cook_book = create(:cook_book, user: user)
        cook_book.recipes << recipe
        get_index_action
      end
      let(:statistics) { assigns(:statistics) }

      it { expect(statistics.followers).to eq(3) }
      it { expect(statistics.following).to eq(1) }
      it { expect(statistics.user_comments).to eq(1) }
      it { expect(statistics.comments_for_user).to eq(1) }
      it { expect(statistics.user_recipes_in_cook_books).to eq(1) }
      it { expect(statistics.recipes).to eq(2) }
      it { expect(statistics.recipes_average_score).to eq(3) }
      it { expect(statistics.cook_books).to eq(2) }
      # TODO: recipes_draft test
    end
  end
end
