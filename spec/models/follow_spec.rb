require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:follower) }
    it { should belong_to(:followed_user) }
  end

  describe "class methods" do
    describe "#send_notification_email" do
      let(:follow) { FactoryBot.create(:follow) }
      it "sends notification email" do
        expect { follow.send_notification_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
