require "rails_helper"

RSpec.describe "users/show", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "users/_show_template" do
    describe "users/_user" do
      before do
        visit user_session_path
        fill_in_and_log_in(user.email, user.password)
        visit user_path(other_user)
      end

      it "displays \"_user\" partial" do
        expect(page).to have_css("article", id: "user-profile")
      end

      it { expect(page).to have_content(I18n.t("users.show.title")) }
    end

    describe "recipes section" do
      before do
        assign(:user, other_user)
        sign_in user
      end

      context "with no recipes" do
        before do
          @recipes = create_list(:recipe, 0)
          @pagy, @recipes = pagy_array(@recipes, items: 10)
          assign(:recipes, @recipes)
          assign(:pagy, @pagy)
          render
        end

        it "displays 0 recipes" do
          expect(rendered).to match /^(?!(.*\/article){3})(.*\/article){2}.*$/
        end

        it "displays info about lack of recipes" do
          expect(rendered).to match I18n.t("recipes.not_found")
        end
      end

      context "with 1 recipe" do
        before do
          @recipes = create_list(:recipe, 1, title: "Food")
          @pagy, @recipes = pagy_array(@recipes, items: 10)
          assign(:recipes, @recipes)
          assign(:pagy, @pagy)
          render
        end

        it "displays the recipe" do
          expect(rendered).to match /^(?!(.*\/article){4})(.*\/article){3}.*$/
          expect(rendered).to match /Food/
        end

        it "doesn't display pagination" do
          expect(rendered).not_to match /pagy_nav/
        end
      end

      context "with 11 recipes" do
        before do
          @recipes = create_list(:recipe, 10)
          @recipes << create(:recipe, title: "papardelle ala arrabiata")
          @pagy, @recipes = pagy_array(@recipes, items: 10)
          assign(:recipes, @recipes)
          assign(:pagy, @pagy)
          render
        end

        it "displays exactly 10 recipes" do
          expect(rendered).to match /^(?!(.*\/article){13})(.*\/article){12}.*$/
        end

        it "doesn't display the 11th recipe" do
          expect(rendered).not_to match /papardelle ala arrabiata/
        end

        it "doesn't allow moving to previous page" do
          expect(rendered).to match /page prev disabled/
        end

        it "allows moving to next page" do
          expect(rendered).to match /page next/
          expect(rendered).not_to match /page next disabled/
        end
      end
    end
  end
end
