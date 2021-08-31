require "rails_helper"

RSpec.describe "reset password process", type: :feature do
  before do
    visit new_user_registration_path
    fill_in_and_sign_up("Username", "email@example.com", "123456", "123456")
    visit new_user_password_path
  end

  context "when enter correct email" do
    let(:last_email) { Devise.mailer.deliveries.last }
    before { fill_in_and_send_reset_password_instructions(User.last.email) }

    it "displays flash success" do
      expect(page).to have_content(I18n.t("devise.passwords.send_instructions"))
      expect(page).to have_css("#flash-success")
    end

    it "sends the user an email" do
      expect(last_email.to).to eq([User.last.email])
      expect(last_email.from).to eq(["no-reply@tasty-book.com"])
      expect(last_email.subject).to eq(I18n.t("devise.mailer.reset_password_instructions.subject"))
      expect(last_email.body).to have_link("Change my password")
    end

    context "and follows link from email" do
      before do
        path_regex = /(?:"https?:\/\/.*?)(\/.*?)(?:")/
        path = last_email.body.match(path_regex)[1]
        visit(path)
      end

      it "redirects to edit password page" do
        expect(page.current_path).to eq(edit_user_password_path)
      end
    end
  end

  context "when leaving email field empty" do
    before do
      ActionMailer::Base.deliveries = []
      fill_in_and_send_reset_password_instructions(nil)
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
      fill_in_and_send_reset_password_instructions("wrong@email.com")
    end

    it "displays error" do
      expect(page).to have_content("Email not found")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end
end
