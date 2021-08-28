require "rails_helper"

RSpec.describe CookBook, type: :model do
  let(:user) { create(:user) }
  subject { create(:cook_book, user: user, visibility: :public) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:recipes) }
  end

  describe "visibility" do
    it { should define_enum_for(:visibility) }
    it { expect(subject.visibility_public?).to eq true }
    it { expect(subject.visibility_private?).to eq false }
  end

  describe "#recipes_visible_for_user" do
    before do
      create_list(:recipe, 4, status: :published, cook_books: [subject])
      create_list(:recipe, 2, status: :draft, cook_books: [subject])
      create(:recipe, status: :draft, user: user, cook_books: [subject])
    end

    context "when the user has drafts in cook_book" do
      let(:recipes) { subject.recipes_visible_for_user(user) }

      it { expect(recipes.size).to eq(5) }
      it { expect(recipes.drafted.size).to eq(1) }
      it { expect(recipes.drafted[0].user).to eq(user) }
    end

    context "when the user is a guest" do
      let(:recipes) { subject.recipes_visible_for_user(nil) }

      it { expect(recipes.size).to eq(4) }
      it { expect(recipes.drafted.size).to eq(0) }
    end
  end
end
