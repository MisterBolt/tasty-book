require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:recipe) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end
end
