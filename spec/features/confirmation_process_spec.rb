require "rails_helper"

RSpec.describe "confirmation process", type: :feature do
  let(:user) { create(:user, confirmed_at: nil) }
  before { visit new_user_confirmation_path }

  context "when enter correct, unconfirmed email" do
    let(:last_email) { Devise.mailer.deliveries.last }
    before { fill_in_and_resend_confirmation(user.email) }

    it "displays flash success" do
      expect(page).to have_content(I18n.t("devise.confirmations.send_instructions"))
      expect(page).to have_css("#flash-success")
    end

    it "sends the user an email" do
      expect(last_email.to).to eq([user.email])
      expect(last_email.from).to eq(["no-reply@tasty-book.com"])
      expect(last_email.subject).to eq(I18n.t("devise.mailer.confirmation_instructions.subject"))
      expect(last_email.body).to have_link("Confirm my account",
        href: "http://test.yourhost.com/users/confirmation?confirmation_token=#{user.confirmation_token}")
    end

    context "and confirm that email" do
      before { visit "http://test.yourhost.com/users/confirmation?confirmation_token=#{user.confirmation_token}" }

      it "displays flash success" do
        expect(page).to have_content(I18n.t("devise.confirmations.confirmed"))
        expect(page).to have_css("#flash-success")
      end
    end
  end

  context "when user is already confirmed" do
    before do
      user.confirm
      ActionMailer::Base.deliveries = []
      fill_in_and_resend_confirmation(user.email)
    end

    it "displays error" do
      expect(page).to have_content("Email was already confirmed, please try signing in")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "when leaving email field empty" do
    before { fill_in_and_resend_confirmation(nil) }

    it "displays error" do
      expect(page).to have_content("Email can't be blank")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "when enter wrong email" do
    before { fill_in_and_resend_confirmation("wrong@email.com") }

    it "displays error" do
      expect(page).to have_content("Email not found")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end
end
