require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    it { should belong_to(:recipe) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe "class methods" do
    describe "#send_notification_email" do
      let(:comment) { FactoryBot.create(:comment) }
      it "sends notification email" do
        expect { comment.send_notification_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
