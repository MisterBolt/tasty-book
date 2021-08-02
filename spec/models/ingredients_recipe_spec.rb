require 'rails_helper'

RSpec.describe IngredientsRecipe, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
  end

  describe 'associations' do
    it { should belong_to(:recipe) }
    it { should belong_to(:ingredient) }
  end
end
