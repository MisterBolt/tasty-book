require "rails_helper"

RSpec.describe "recipes/index", type: :view do
  include Pagy::Backend
  let(:user) { create(:user) }

  context "with no recipes" do
    before do
      @recipes = create_list(:recipe, 0)
      @pagy, @recipes = pagy_array(@recipes, items: 10)
      assign(:recipes, @recipes)
      assign(:pagy, @pagy)
      render
    end

    it "displays 0 recipes" do
      expect(rendered).not_to match /article/
    end

    it "displays info about lack of recipes" do
      expect(rendered).to match I18n.t("recipes.not_found")
    end
  end

  context "with 1 recipe as guest" do
    before do
      @recipes = create_list(:recipe, 1, title: "Food")
      @pagy, @recipes = pagy_array(@recipes, items: 10)
      assign(:recipes, @recipes)
      assign(:pagy, @pagy)
      render
    end

    it "displays the recipe" do
      expect(rendered).to match /article/
      expect(rendered).to match /Food/
    end

    it "doesn't display the dropdown menu" do
      expect(rendered).not_to match /dropdown/
    end

    it "doesn't display pagination" do
      expect(rendered).not_to match /pagy_nav/
    end
  end

  context "with 11 recipes as user" do
    before do
      sign_in user
      @recipes = create_list(:recipe, 10)
      @recipes << create(:recipe, title: "papardelle ala arrabiata")
      @pagy, @recipes = pagy_array(@recipes, items: 10)
      assign(:recipes, @recipes)
      assign(:pagy, @pagy)
      render
    end

    it "displays exactly 10 recipes" do
      expect(rendered).to match /^(?!(.*\/article){11})(.*\/article){10}.*$/
    end

    it "doesn't display the 11th recipe" do
      expect(rendered).not_to match /papardelle ala arrabiata/
    end

    it "displays the dropdown menu" do
      expect(rendered).to match /dropdown/
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
