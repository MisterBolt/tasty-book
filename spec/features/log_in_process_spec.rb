require "rails_helper"

RSpec.describe "log in process", type: :feature do
  let!(:user) { create(:user) }
  before { visit user_session_path }

  context "when enter correct email and password with checked \"Remember me\" box" do
    before { fill_in_and_log_in(user.email, user.password, true) }

    it "signs me in" do
      expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
      expect(page).to have_css("#flash-success")
    end

    it "remembers me after browser restart" do
      expire_cookies
      visit root_path

      expect(page).to have_link(I18n.t("buttons.log_out"), href: "/users/sign_out")
    end
  end

  context "when enter correct email and password with unchecked \"Remember me\" box" do
    before { fill_in_and_log_in(user.email, user.password) }

    it "signs me in" do
      expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
    end

    it "does not remember me after browser restart" do
      expire_cookies
      visit root_path

      expect(page).to have_link(I18n.t("buttons.log_in"), href: "/users/sign_in")
    end
  end

  context "when enter incorrect email" do
    before { fill_in_and_log_in("incorrect_user@example.com", user.password) }

    it "does not sign me in" do
      expect(page).to have_content(I18n.t("devise.failure.not_found_in_database"))
      expect(page).to have_css("#flash-error")
    end
  end

  context "when enter incorrect password" do
    before { fill_in_and_log_in(user.email, "incorrect_password") }

    it "does not sign me in" do
      expect(page).to have_content(I18n.t("devise.failure.invalid"))
      expect(page).to have_css("#flash-error")
    end
  end
end
