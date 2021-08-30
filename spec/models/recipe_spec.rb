# frozen_string_literal: true

require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:time_in_minutes_needed) }
    it { is_expected.to validate_presence_of(:difficulty) }
    it { is_expected.to validate_presence_of(:categories) }
    it { is_expected.to validate_presence_of(:layout) }
    it { is_expected.to validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(%i[draft published]) }
    it { should define_enum_for(:difficulty).with_values(%i[EASY MEDIUM HARD]) }
    it { should define_enum_for(:layout).with_values(%i[layout_1 layout_2 layout_3]) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:recipe_scores) }
    it { should have_many(:scorers) }
    it { should have_many(:comments) }
    it { should have_many(:ingredients_recipes) }
    it { should have_many(:ingredients) }
    it { should have_and_belong_to_many(:cook_books) }
    it { should have_and_belong_to_many(:categories) }
  end

  describe "#average_score" do
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

  describe ".average_score" do
    let(:user) { create(:user) }
    let(:recipes) { create_list(:recipe, 5, user: user) }
    before { create_list(:recipe_score, 5) }

    context "when there are no scores" do
      it { expect(user.recipes.average_score).to eq(0.0) }
    end

    context "when all recipes have scores" do
      before do
        5.times do |i|
          create(:recipe_score, recipe: recipes[i], score: i + 1)
        end
      end

      it { expect(user.recipes.average_score).to eq(3.0) }
    end

    context "when some recipes have no score" do
      before do
        create(:recipe_score, recipe: recipes[0], score: 2)
        create(:recipe_score, recipe: recipes[2], score: 5)
      end

      it { expect(user.recipes.average_score).to eq(3.5) }
    end
  end

  describe "#toggle_favourite" do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    before { recipe.toggle_favourite(user) }

    context "when user hasn't got this recipe in his favourites" do
      it "adds this recipe to his favourites" do
        expect(user.cook_books[0].recipes.count).to eq(1)
      end
    end

    context "when user has got this recipe in his favourites" do
      before { recipe.toggle_favourite(user) }

      it "removes this recipe from his favourites" do
        expect(user.cook_books[0].recipes.count).to eq(0)
      end
    end
  end

  describe ".sort_by_kind_and_order" do
    before do
      recipes = [
        create(:recipe, title: "TitleF", difficulty: "EASY", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleG", difficulty: "EASY", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleH", difficulty: "MEDIUM", time_in_minutes_needed: 12),
        create(:recipe, title: "TitleI", difficulty: "MEDIUM", time_in_minutes_needed: 7),
        create(:recipe, title: "TitleA", difficulty: "HARD", time_in_minutes_needed: 10),
        create(:recipe, title: "TitleB", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleC", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleD", difficulty: "HARD", time_in_minutes_needed: 19),
        create(:recipe, title: "TitleE", difficulty: "HARD", time_in_minutes_needed: 29),
        create(:recipe, title: "TitleJ", difficulty: "MEDIUM", time_in_minutes_needed: 10),
        create(:recipe, title: "TitleK", difficulty: "MEDIUM", time_in_minutes_needed: 6),
        create(:recipe, title: "TitleL", difficulty: "MEDIUM", time_in_minutes_needed: 11)
      ]
      8.times do |i|
        create(:recipe_score, recipe: recipes[i], score: (i % 5) + 1)
      end
    end

    context "when kind: title, order: ASC" do
      subject { Recipe.sort_by_kind_and_order("title", "ASC").map(&:title) }

      it { expect(subject).to eq(("A".."L").map { |letter| "Title#{letter}" }) }
    end

    context "when kind: title, order: DESC" do
      subject { Recipe.sort_by_kind_and_order("title", "DESC").map(&:title) }

      it { expect(subject).to eq(("A".."L").to_a.reverse.map { |letter| "Title#{letter}" }) }
    end

    context "when kind: difficulty, order: ASC" do
      subject { Recipe.sort_by_kind_and_order("difficulty", "ASC").map(&:difficulty) }

      it { expect(subject).to eq(["EASY"] * 2 + ["MEDIUM"] * 5 + ["HARD"] * 5) }
    end

    context "when kind: difficulty, order: DESC" do
      subject { Recipe.sort_by_kind_and_order("difficulty", "DESC").map(&:difficulty) }

      it { expect(subject).to eq(["HARD"] * 5 + ["MEDIUM"] * 5 + ["EASY"] * 2) }
    end

    context "when kind: time_in_minutes_needed, order: ASC" do
      subject { Recipe.sort_by_kind_and_order("time_in_minutes_needed", "ASC").map(&:time_in_minutes_needed) }

      it { expect(subject).to eq([6, 7, 10, 10, 11, 12, 19, 19, 19, 29, 29, 29]) }
    end

    context "when kind: time_in_minutes_needed, order: DESC" do
      subject { Recipe.sort_by_kind_and_order("time_in_minutes_needed", "DESC").map(&:time_in_minutes_needed) }

      it { expect(subject).to eq([29, 29, 29, 19, 19, 19, 12, 11, 10, 10, 7, 6]) }
    end

    context "when kind: score, order: ASC" do
      subject { Recipe.sort_by_kind_and_order("score", "ASC").map(&:average_score) }

      it { expect(subject).to eq([0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 2.0, 3.0, 3.0, 4.0, 5.0]) }
    end

    context "when kind: score, order: DESC" do
      subject { Recipe.sort_by_kind_and_order("score", "DESC").map(&:average_score) }

      it { expect(subject).to eq([5.0, 4.0, 3.0, 3.0, 2.0, 2.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]) }
    end
  end

  describe ".published" do
    before do
      create_list(:recipe, 6, status: :published)
      create_list(:recipe, 4, status: :draft)
    end
    subject { Recipe.published }

    it { expect(subject.size).to eq(6) }
  end

  describe ".drafted" do
    before do
      create_list(:recipe, 6, status: :published)
      create_list(:recipe, 4, status: :draft)
    end
    subject { Recipe.drafted }

    it { expect(subject.size).to eq(4) }
  end
end
