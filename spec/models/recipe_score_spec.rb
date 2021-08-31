require "rails_helper"

RSpec.describe RecipeScore, type: :model do
  describe "validations" do
    let(:user) { create(:user) }
    let(:recipe) { create(:recipe) }
    subject { RecipeScore.new(user_id: user.id, recipe_id: recipe.id, score: 5) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:recipe_id) }
    it { is_expected.to validate_presence_of(:recipe_id) }
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_inclusion_of(:score).in_array((1..5).to_a) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:recipe) }
  end

  describe "class methods" do
    describe "#send_notification_email" do
      let(:user) { create(:user) }
      let(:recipe) { create(:recipe, user: user) }
      let(:recipe_score) { create(:recipe_score, recipe: recipe) }

      it "sends notification email" do
        expect { recipe_score.send_notification_email }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      context "when author of recipe is deleted" do
        before do
          user.anonymize
        end

        it "doesn't send notification email" do
          expect { recipe_score.send_notification_email }.not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end
end
