require "rails_helper"

RSpec.describe "recipes/show", type: :view do
  let!(:user1) { create(:user) }
  let!(:recipe) { create(:recipe, layout: 2, user: user1) }
  let!(:comment) { create(:comment, user: user1, recipe: recipe) }

  describe "when site is used by the user" do
    before do
      login_as(user1)
      visit recipe_path(recipe)
    end

    it "displays recipe data" do
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.user.username)
      expect(page).to have_content(recipe.preparation_description)
    end

    context "and user hasn't got this recipe in his favourites" do
      it "displays heart button with title \"Add to favourites\"" do
        expect(page).to have_css("svg", class: "heart-button")
        expect(page).to have_css("title", text: t("recipes.update_favourite.add_favourite"))
      end
    end

    context "and user has got this recipe in his favourites" do
      before do
        recipe.toggle_favourite(user1)
        visit recipe_path(recipe)
      end

      it "displays red heart button with title \"Remove from favourites\"" do
        expect(page).to have_css("svg", class: "heart-button fill-red-500")
        expect(page).to have_css("title", text: t("recipes.update_favourite.remove_favourite"))
      end
    end

    context "who is the author of the recipe" do
      it "displays edit and delete recipe options" do
        find_link("Edit")
        find_link("Delete")
      end
    end

    context "who isn't the author of the recipe" do
      let(:user2) { create(:user) }

      it "shouldn't display edit and delete recipe options" do
        sign_out(user1)
        login_as(user2)
        visit recipe_path(recipe)
        expect(page).to have_no_link("Edit")
        expect(page).to have_no_link("Delete")
      end
    end

    it "displays comments" do
      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    it "can add a comment", js: true do
      fill_in "comment[body]", with: "Test content"
      click_on t("comments.form.add")
      expect(page).to have_content("Test content")
    end
  end

  describe "when site is used by the guest" do
    before { visit recipe_path(recipe) }

    it "doesn't display heart button for favourites" do
      expect(page).not_to have_css("svg", class: "heart_button")
    end

    it "displays recipe data" do
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.user.username)
      expect(page).to have_content(recipe.preparation_description)
    end

    it "shouldn't display edit and delete recipe options" do
      expect(page).to have_no_link("Edit")
      expect(page).to have_no_link("Delete")
    end

    it "displays comments" do
      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    it "can add a comment", js: true do
      fill_in "comment[body]", with: "Test content"
      click_on t("comments.form.add")
      expect(page).to have_content(t("comments.guest_comment_modal.title"))
      expect(page).to have_content(t("comments.guest_comment_modal.subtitle"))
    end
  end
end
