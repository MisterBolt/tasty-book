require "rails_helper"
require "pundit/rspec"

RSpec.describe AdminPanelPolicy, type: :policy do
  permissions :comments? do
    subject { AdminPanelPolicy }
    let(:admin) { create(:user, admin: true) }
    let(:user) { create(:user, admin: false) }

    context "with admin" do
      it { expect(subject).to permit(admin) }
    end

    context "with regular user" do
      it { expect(subject).not_to permit(user) }
    end

    context "with guest" do
      it { expect(subject).not_to permit(nil) }
    end
  end
end
