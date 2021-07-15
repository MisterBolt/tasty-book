# frozen_string_literal: true
require "rails_helper"

RSpec.describe Recipe, type: :model do
    it "must have a title" do
        recipe = Recipe.create!(title: "Pomidorowa z rosolu z wczoraj")
        expect(recipe.title).to eq("Pomidorowa z rosolu z wczoraj")
    end

    it "have a description" do
        recipe = Recipe.create!(title: "Pomidorowa z rosolu z wczoraj", description: "Dodajemy koncentrat pomidorowy")
        expect(recipe.description).to eq("Dodajemy koncentrat pomidorowy")
    end

    it "is not valid without a title" do
          is_expected.to validate_presence_of(:title)
      end

end
