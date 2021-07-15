require "rails_helper"

RSpec.describe Recipe, type: :model do
  describe "associations" do
    it { should have_many(:comments) }
  end
end
