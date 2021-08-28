require "rails_helper"

RSpec.describe "recipes/create", type: :view do
  let!(:user) { create(:user) }
  let!(:recipe) { create(:recipe, user: user, layout: 2) }

  before do
    login_as(user)
    visit edit_recipe_path(recipe)
  end

  context("with not enough data") do
    it "displays error", js: true do
      fill_in_recipe_data("", "")
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "when editing recipe" do
    it "shows all ingredients and sections" do
      expect(all(".ingredient_set").count).to eq(recipe.ingredients.count)
      expect(all(".section_set").count).to eq(recipe.sections.count)
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

  context "with no sections" do
    it "displays error", js: true do
      remove_sections
      add_ingredients_to_recipe(1)
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "when editing section" do
    it "doesn't add new section", js: true do
      find(:css, "fieldset .section-title").set("New title")
      expect {
        click_button I18n.t("buttons.update_recipe")
      }.not_to change { Section.count }
      expect(page).to have_content("New title")
    end
  end

  context "when editing ingredient" do
    it "doesn't add new ingredient" do
      find(:css, "fieldset input[list='ingredients_dropdown']").set("New ingredient")
      expect {
        click_button I18n.t("buttons.update_recipe")
        sleep(1)
      }.not_to change { IngredientsRecipe.count }
      expect(page).to have_content("New ingredient")
    end
  end

  context "with valid data" do
    it "updates recipe", js: true do
      fill_in_recipe_data("Soup", 40)
      add_ingredients_to_recipe(1)
      click_button I18n.t("buttons.update_recipe")
      expect(page).to have_content("Soup")
    end
  end
end
