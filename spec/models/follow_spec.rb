require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:follower) }
    it { should belong_to(:followed_user) }
  end
end
