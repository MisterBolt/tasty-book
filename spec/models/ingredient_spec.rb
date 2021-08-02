require "rails_helper"

RSpec.describe Ingredient, type: :model do
  describe "validations" do
    subject { create(:ingredient) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { should have_many(:recipes) }
    it { should have_many(:ingredients_recipes) }
  end
end
