require "rails_helper"

RSpec.describe "recipes/show", type: :view do
  let!(:user1) { create(:user) }
  let!(:recipe) { create(:recipe, layout: 2, user: user1) }
  let!(:comment) { create(:comment, user: user1, recipe: recipe) }

  context "when site is used by the user" do
    it "display recipe data" do
      login_as(user1)
      visit recipe_path(recipe)
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.user.username)
      recipe.sections.each do |section|
        expect(page).to have_content(section.title)
        expect(page).to have_content(section.body)
      end
    end

    describe "who is the author of the recipe" do
      it "display edit and delete recipe options" do
        login_as(user1)
        visit recipe_path(recipe)
        find_link("Edit")
        find_link("Delete")
      end
    end

    describe "who isn't the author of the recipe" do
      let(:user2) { create(:user) }

      it "shouldn't display edit and delete recipe options" do
        login_as(user2)
        visit recipe_path(recipe)
        expect(page).to have_no_link("Edit")
        expect(page).to have_no_link("Delete")
      end
    end

    it "display comments" do
      login_as(user1)
      visit recipe_path(recipe)
      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    it "can add a comment", js: true do
      login_as(user1)
      visit recipe_path(recipe)
      fill_in "comment[body]", with: "Test content"
      click_on t("comments.form.add")
      expect(page).to have_content("Test content")
    end
  end

  context "when site is used by the guest" do
    it "display recipe data" do
      visit recipe_path(recipe)
      expect(page).to have_content(recipe.title)
      expect(page).to have_content(recipe.user.username)
      recipe.sections.each do |section|
        expect(page).to have_content(section.title)
        expect(page).to have_content(section.body)
      end
    end

    it "shouldn't display edit and delete recipe options" do
      visit recipe_path(recipe)
      expect(page).to have_no_link("Edit")
      expect(page).to have_no_link("Delete")
    end

    it "display comments" do
      visit recipe_path(recipe)
      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    it "can add a comment", js: true do
      visit recipe_path(recipe)
      fill_in "comment[body]", with: "Test content"
      click_on t("comments.form.add")
      expect(page).to have_content("Test content")
      expect(page).to have_content(t("comments.show.guest"))
    end
  end
end
