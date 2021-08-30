require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { should belong_to(:follower) }
    it { should belong_to(:followed_user) }
  end

  describe "class methods" do
    describe "#send_notification_email" do
      let(:user) { create(:user) }
      let(:follow) { create(:follow, followed_user: user) }

      it "sends notification email" do
        expect { follow.send_notification_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      context "when followed_user is deleted" do
        before do
          user.anonymize_user
        end

        it "doesn't send notification email" do
          expect { follow.send_notification_email }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end
end
