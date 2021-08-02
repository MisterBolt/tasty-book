require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe "associations" do
    it { should have_many(:recipe_scores) }
    it { should have_many(:scored_recipes) }
    it { should have_many(:cook_books) }
    it { should have_many(:comments) }
    it { should have_many(:given_follows) }
    it { should have_many(:followings) }
    it { should have_many(:received_follows) }
    it { should have_many(:followers) }
    it { should have_many(:comments) }
    it { should have_many(:recipes) }
  end
end
