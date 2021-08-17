require 'rails_helper'

RSpec.describe "recipes/create", type: :view do
    let!(:user) { create(:user) }

    before do 
        login_as(user)
        visit new_recipe_path
    end

    context("with not enough data") do
        it "displays error" do
            fill_in_recipe_data("", "", "")
            click_button I18n.t("buttons.create_new_recipe")
            expect(page).to have_selector('#flash-error')
        end
    end

    context "with no ingredients" do
        it "displays error" do
            fill_in_recipe_data("Soup", "test", "20")
            click_button I18n.t("buttons.create_new_recipe")
            expect(page).to have_selector('#flash-error')
        end
    end

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
    end
end