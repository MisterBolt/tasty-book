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
      fill_in_recipe_data("", "", "")
      add_categories
      add_ingredients_to_recipe(4)
      click_button I18n.t("buttons.create_new_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no ingredients" do
    it "displays error" do
      fill_in_recipe_data("Soup", "test", "20")
      add_categories
      click_button I18n.t("buttons.create_new_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "with no categories" do
    it "displays error", js: true do
      fill_in_recipe_data("Soup", "test", "20")
      add_ingredients_to_recipe(2)
      click_button I18n.t("buttons.create_new_recipe")
      expect(page).to have_selector("#flash-error")
    end
  end

  context "when adding new ingredient" do
    it "saves it in DB", js: true do
      fill_in_recipe_data("Soup", "test", "20")
      add_categories
      find(:css, "#add_ingredient").click
      all("fieldset input[list='ingredients_dropdown']").last.set("New Ingredient")
      expect {
        click_button I18n.t("buttons.create_new_recipe")
        # Wait for page to load
        sleep(1)
      }.to change { Ingredient.count }.by(1)
      expect(page).to have_content("New Ingredient")
    end
  end

<<<<<<< HEAD
  context "with valid data" do
    it "saves recipe", js: true do
      fill_in_recipe_data("Soup", "test", "20")
      add_ingredients_to_recipe(3)
      add_categories
      expect {
        click_button I18n.t("buttons.create_new_recipe")
        # Wait for page to load
        sleep(1)
      }.to change { Recipe.count }.by(1)
      expect(page).to have_content("Soup")
=======
    context "with no categories" do
        it "displays error" do
            fill_in_recipe_data("Soup", "test", "20")
            5.times do
                ingredient = create(:ingredient)
                add_ingredient_to_recipe(ingredient.name, "4", "ml")
            end
        end
    end

    context "with valid data" do
        it "saves recipe" do
            fill_in_recipe_data("Soup", "test", "20")
            5.times do
                ingredient = create(:ingredient)
                add_ingredient_to_recipe(ingredient.name, "4", "ml")
            end
            c = create(:category)
            find(:css, "input[value='#{c.id}']").set(true)
            expect {
                click_button I18n.t("buttons.create_new_recipe")
            }.to change(Recipe, :count).by(1)
        end
>>>>>>> 3d74e44... Added autocomplete after refreshing
    end
  end
end
