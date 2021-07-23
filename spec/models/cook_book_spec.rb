require "rails_helper"

RSpec.describe CookBook, type: :model do
  subject { create(:cook_book, user: create(:user), visibility: :public) }

  context "regarding validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:title) }
  end

  context "regarding associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:recipes) }
  end

  context "regarding visibility" do
    it { should define_enum_for(:visibility) }
    it { expect(subject.visibility_public?).to eq true }
    it { expect(subject.visibility_private?).to eq false }
  end
end
