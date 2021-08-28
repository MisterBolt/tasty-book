require "rails_helper"

RSpec.describe Section, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe "associations" do
    it { should belong_to(:recipe) }
  end
end
