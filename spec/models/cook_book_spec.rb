require "rails_helper"

RSpec.describe CookBook, type: :model do
  subject { create(:cook_book, user: create(:user)) }
  
  it { should define_enum_for(:visibility) }

  context "regarding validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:title) }
  end

  context "regarding associations" do
    it { should belong_to(:user) }
    it { should have_and_belong_to_many(:recipes) }
  end
end
