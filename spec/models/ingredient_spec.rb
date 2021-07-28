require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe "associations" do
    it { should have_and_belong_to_many(:recipes) }
  end
end
