require "rails_helper"

RSpec.describe "recipes/create", type: :view do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe) }

  before do
    login_as(user)
    visit edit_recipe_path(recipe)
  end

  context("with not enough data") do
    it "displays error", js: true do
      fill_in_recipe_data("", "", "")
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no ingredients" do
    it "displays error", js: true do
      remove_ingredients
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no categories" do
    it "displays error", js: true do
      remove_categories
      add_ingredients_to_recipe(1)
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with valid data" do
    it "updates recipe", js: true do
      fill_in_recipe_data("Soup", "test", "20")
      add_ingredients_to_recipe(1)
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_content("Soup")
    end
  end
end
