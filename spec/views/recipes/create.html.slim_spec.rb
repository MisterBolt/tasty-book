require "rails_helper"

RSpec.describe "recipes/create", type: :view do
  let!(:user) { create(:user) }

  before do
    login_as(user)
    create_list(:ingredient, 5)
    create_list(:category, 5)
    visit new_recipe_path
  end

  context("with not enough data") do
    it "displays error", js: true do
      fill_in_recipe_data("", "")
      add_sections_to_recipe(2)
      add_categories
      add_ingredients_to_recipe(4)
      click_button I18n.t("buttons.publish_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no ingredients" do
    it "displays error", js: true do
      fill_in_recipe_data("Soup", "20")
      add_categories
      add_sections_to_recipe(2)
      click_button I18n.t("buttons.publish_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no categories" do
    it "displays error", js: true do
      fill_in_recipe_data("Soup", "20")
      add_ingredients_to_recipe(2)
      add_sections_to_recipe(2)
      click_button I18n.t("buttons.publish_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no sections" do
    it "displays error", js: true do
      fill_in_recipe_data("Soup", "20")
      add_ingredients_to_recipe(2)
      add_categories
      click_button I18n.t("buttons.publish_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "when adding new ingredient" do
    it "saves it in DB", js: true do
      fill_in_recipe_data("Soup", "20")
      add_categories
      add_sections_to_recipe(2)
      add_ingredient("New Ingredient", 2, 0)
      expect {
        click_button I18n.t("buttons.publish_recipe")
        # Wait for page to load
        sleep(1)
      }.to change { Ingredient.count }.by(1)
      expect(page).to have_content("New Ingredient")
    end
  end

  context "with valid data" do
    it "saves recipe", js: true do
      fill_in_recipe_data("Soup", "20")
      add_ingredients_to_recipe(3)
      add_categories
      add_sections_to_recipe(2)
      expect {
        click_button I18n.t("buttons.publish_recipe")
        # Wait for page to load
        sleep(1)
      }.to change { Recipe.count }.by(1)
      expect(page).to have_content("Soup")
    end
  end
end
