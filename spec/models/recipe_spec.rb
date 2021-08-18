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

  describe "average_score method" do
    subject { create(:recipe) }

    context "when there are no scores" do
      it { expect(subject.average_score).to eq(0.0) }
    end

    context "when there are 2 scores" do
      before do
        create(:recipe_score, recipe: subject, score: 2)
        create(:recipe_score, recipe: subject, score: 4)
      end

      it { expect(subject.average_score).to eq(3.0) }
    end
  end

  describe "self.average_score method" do
    let(:user) { create(:user) }
    let(:recipes) { create_list(:recipe, 5, user: user) }
    before { create_list(:recipe_score, 5) }

    context "when there are no scores" do
      it { expect(user.recipes.average_score).to eq(0.0) }
    end

    context "when all recipes has scores" do
      before do
        (1..5).each do |i|
          create(:recipe_score, recipe: recipes[i - 1], score: i)
        end
      end

      it { expect(user.recipes.average_score).to eq(3.0) }
    end

    context "when some recipes has no score" do
      before do
        create(:recipe_score, recipe: recipes[0], score: 2)
        create(:recipe_score, recipe: recipes[2], score: 5)
      end

      it { expect(user.recipes.average_score).to eq(3.5) }
    end
  end
end
