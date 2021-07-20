require "rails_helper"
require "will_paginate/array"

RSpec.describe "recipes/index", type: :view do

  context "with no recipes" do
    before(:each) do  
      allow(view).to receive(:user_signed_in?) { false }
      @recipes = [].paginate(page: 1, per_page: 10)
      assign(:recipes, @recipes)
    end

    it "displays 0 recipes" do
      render
      expect(rendered).not_to match /article/
    end

    it "displays info about lack of recipes" do
      render
      expect(rendered).to match /No recipes found/
    end
    
  end

  context "with 1 recipe as guest" do
    before(:each) do  
      allow(view).to receive(:user_signed_in?) { false }
      @recipes = [Recipe.create!(
        title: "Spaghetti bolognese",
        description: "Klasyczne spaghetti"
      )]
      @recipes = @recipes.paginate(page: 1, per_page: 10)
      assign(:recipes, @recipes)
    end

    it "displays the recipe" do
      render
      expect(rendered).to match /article/
      expect(rendered).to match /Spaghetti bolognese/
    end

    it "doesn't display button for adding the recipe to cook book" do
      render
      expect(rendered).not_to match /.heart/
    end

    it "doesn't display pagination" do
      render
      expect(rendered).not_to match /previous_page/
      expect(rendered).not_to match /next_page/
      expect(rendered).not_to match /recipes\/\?page/
    end
    
  end

  context "with 11 recipes as user" do
    before(:each) do  
      allow(view).to receive(:user_signed_in?) { true }
      @recipes = []
      10.times do
        @recipes << Recipe.create!(
          title: "Spaghetti bolognese",
          description: "Klasyczne spaghetti"
        )
      end
      @recipes << Recipe.create!(
          title: "Pappardelle all'arrabbiata",
          description: "Pyszne danie dla calej rodziny"
      )
      @recipes = @recipes.paginate(page: 1, per_page: 10)
      assign(:recipes, @recipes)
    end

    it "displays exactly 10 recipes" do
      render
      expect(rendered).to match /^(?!(.*\/article){11})(.*\/article){10}.*$/
    end

    it "doesn't display the 11th recipe" do
      render
      expect(rendered).not_to match /Pappardelle all'arrabbiata/
    end

    it "displays button for adding the recipe to cook book" do
      render
      expect(rendered).to match /.heart/
    end

    it "doesn't allow moving to previous page" do
      render
      expect(rendered).to match /previous_page disabled/
    end

    it "allows moving to next page" do
      render
      expect(rendered).to match /next_page/
      expect(rendered).not_to match /next_page disabled/
    end
    
  end

end