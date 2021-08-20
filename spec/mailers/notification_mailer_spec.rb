require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  describe "comment_notification" do
    let(:comment) { FactoryBot.create(:comment) }
    let(:mail) { NotificationMailer.comment_notification(user, comment) }
    describe "headers" do
      it "is titled 'Comment notification'" do
        expect(mail.subject).to eq("Comment notification")
      end
      it "is sent to user email address" do
        expect(mail.to).to eq([user.email])
      end
    end

    describe "body" do
      it "includes user name" do
        expect(mail.body.encoded).to match(user.username)
      end
      it "includes comment author name" do
        expect(mail.body.encoded).to match(comment.user.username)
      end
      it "includes comment body" do
        expect(mail.body.encoded).to match(comment.body)
      end
    end
  end

  describe "follow_notification" do
    let(:follower) { FactoryBot.create(:user) }
    let(:mail) { NotificationMailer.follow_notification(user, follower) }
    describe "headers" do
      it "is titled 'Follow notification'" do
        expect(mail.subject).to eq("Follow notification")
      end
      it "is sent to user email address" do
        expect(mail.to).to eq([user.email])
      end
    end

    describe "body" do
      it "includes user name" do
        expect(mail.body.encoded).to match(user.username)
      end
      it "includes follower name" do
        expect(mail.body.encoded).to match(follower.username)
      end
    end
  end

  describe "recipe_score_notification" do
    let(:recipe_score) { FactoryBot.create(:recipe_score) }
    let(:mail) { NotificationMailer.recipe_score_notification(user, recipe_score) }
    describe "headers" do
      it "is titled 'Recipe score notification'" do
        expect(mail.subject).to eq("Recipe score notification")
      end
      it "is sent to user email address" do
        expect(mail.to).to eq([user.email])
      end
    end

    describe "body" do
      it "includes user name" do
        expect(mail.body.encoded).to match(user.username)
      end
      it "includes scored recipe title" do
        expect(mail.body.encoded).to match(recipe_score.recipe.title)
      end
      it "includes score" do
        expect(mail.body.encoded).to match(/[12345]/)
      end
      it "includes scorer name" do
        expect(mail.body.encoded).to match(recipe_score.user.username)
      end
    end
  end
end
