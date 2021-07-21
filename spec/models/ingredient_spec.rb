require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(30) }
  end

  describe "associations" do
    it { should have_many(:recipe_ingredients) }
    it { should have_many(:recipes) }
  end
end
