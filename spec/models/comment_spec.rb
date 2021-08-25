require "rails_helper"

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment, status: :approved) }

  describe "associations" do
    it { should belong_to(:recipe) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
  end

  describe "status" do
    it { should define_enum_for(:status) }
    it { expect(comment.status_approved?).to eq(true) }
    it { expect(comment.status_awaiting?).to eq(false) }
    it { expect(comment.status_rejected?).to eq(false) }
  end

  describe ".awaiting" do
    before { 6.times { |n| create(:comment, status: Comment.statuses.keys[n % 3]) } }
    subject { Comment.awaiting.map(&:status) }

    it { expect(subject).to eq(["awaiting"] * 2) }
  end

  describe ".approved" do
    before { 6.times { |n| create(:comment, status: Comment.statuses.keys[n % 3]) } }
    subject { Comment.approved.map(&:status) }

    it { expect(subject).to eq(["approved"] * 2) }
  end

  describe "class methods" do
    describe "#send_notification_email" do
      it "sends notification email" do
        expect { comment.send_notification_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end
  end
end
