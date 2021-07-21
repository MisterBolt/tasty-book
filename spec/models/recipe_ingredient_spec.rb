require 'rails_helper'

RSpec.describe RecipeIngredient, type: :model do
  describe "associations" do
    it { should belong_to(:recipe) }
    it { should belong_to(:ingredient) }
  end
end
