# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:preparation_description) }
    it { is_expected.to validate_presence_of(:time_in_minutes_needed) }
    it { is_expected.to validate_presence_of(:difficulty) }
    it { is_expected.to validate_presence_of(:categories) }
    it { should define_enum_for(:difficulty).with_values([:EASY, :MEDIUM, :HARD]) }
  end

  describe "associations" do
    it { should have_many(:comments) }
    it { should have_many(:ingredients) }
    it { should have_many(:ingredients_recipes) }
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:cook_books) }
    it { should have_and_belong_to_many(:categories) }
  end
end
