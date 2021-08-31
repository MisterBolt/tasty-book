require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }
  end

  describe "associations" do
    it { should have_many(:recipes) }
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

  describe "following methods" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "when user follow other user" do
      before { user.follow(other_user) }

      it "following?" do
        expect(user.following?(other_user)).to eq(other_user.followers.include?(user))
      end

      it "follow" do
        expect(user.following?(other_user)).to eq(true)
      end

      it "unfollow" do
        user.unfollow(other_user)

        expect(user.following?(other_user)).to eq(false)
      end
    end

    context "when user try to follow himself" do
      before { user.follow(user) }

      it "doesn't follow" do
        expect(user.following?(user)).to eq(false)
      end
    end
  end

  describe "#favourites_cook_book" do
    let(:user) { create(:user) }

    it "returns favourites cook book" do
      expect(user.favourites_cook_book.favourite).to eq(true)
    end
  end

  describe "#disabled?" do
    let(:user) { create(:user) }

    context "when user isn't disabled" do
      it { expect(user.disabled?).to eq(false) }
    end

    context "when user is disabled" do
      before { user.anonymize }
      it { expect(user.disabled?).to eq(true) }
    end
  end
end
