require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:comments) }
  end

  describe "validations" do
    let!(:user) { create(:user) }
    it { is_expected.to validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
  end
end
