require "rails_helper"

RSpec.describe "confirmation process", type: :feature do
  before do
    visit new_user_registration_path
    fill_in_and_sign_up("Username", "email@example.com", "123456", "123456")
    visit new_user_confirmation_path
  end

  context "when enter correct, unconfirmed email" do
    let(:last_email) { Devise.mailer.deliveries.last }
    before { fill_in_and_resend_confirmation(User.last.email) }

    it "displays flash success" do
      expect(page).to have_content(I18n.t("devise.confirmations.send_instructions"))
      expect(page).to have_css("#flash-success")
    end

    it "sends the user an email" do
      expect(last_email.to).to eq([User.last.email])
      expect(last_email.from).to eq(["no-reply@tasty-book.com"])
      expect(last_email.subject).to eq(I18n.t("devise.mailer.confirmation_instructions.subject"))
      expect(last_email.body).to have_link("Confirm my account",
        href: "http://test.yourhost.com/users/confirmation?confirmation_token=#{User.last.confirmation_token}")
    end

    context "and confirm that email" do
      before { visit "http://test.yourhost.com/users/confirmation?confirmation_token=#{User.last.confirmation_token}" }

      it "displays flash success" do
        expect(page).to have_content(I18n.t("devise.confirmations.confirmed"))
        expect(page).to have_css("#flash-success")
      end
    end
  end

  context "when user is already confirmed" do
    before do
      User.last.confirm
      ActionMailer::Base.deliveries = []
      fill_in_and_resend_confirmation(User.last.email)
    end

    it "displays error" do
      expect(page).to have_content("Email was already confirmed, please try signing in")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "when leaving email field empty" do
    before do
      ActionMailer::Base.deliveries = []
      fill_in_and_resend_confirmation(nil)
    end

    it "displays error" do
      expect(page).to have_content("Email can't be blank")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "when enter wrong email" do
    before do
      ActionMailer::Base.deliveries = []
      fill_in_and_resend_confirmation("wrong@email.com")
    end

    it "displays error" do
      expect(page).to have_content("Email not found")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end
end
