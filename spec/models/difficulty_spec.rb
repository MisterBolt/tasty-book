require 'rails_helper'

RSpec.describe Difficulty, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_inclusion_of(:name).in_array(%w[EASY MEDIUM HARD]) }
  end

  describe "associations" do
    it { should have_many(:recipes) }
  end
end
