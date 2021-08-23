require "rails_helper"

RSpec.describe "log in process", type: :feature do
  describe "when user is confirmed" do
    before do
      visit new_user_registration_path
      fill_in_and_sign_up("Username", "email@example.com", "123456", "123456")
      User.last.confirm
      visit user_session_path
    end

    context "and logging in from landing page" do
      before { fill_in_and_log_in(User.last.email, "123456") }

      it "redirects me to recipes path" do
        expect(page).to have_current_path(recipes_path)
      end
    end

    context "and logging in from other page" do
      before do
        visit cook_books_path
        visit user_session_path
        fill_in_and_log_in(User.last.email, "123456")
      end

      it "redirects me back to this page" do
        expect(page).to have_current_path(cook_books_path)
      end
    end

    context "and enter correct email and password with checked \"Remember me\" box" do
      before { fill_in_and_log_in(User.last.email, "123456", true) }

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

    context "and enter correct email and password with unchecked \"Remember me\" box" do
      before { fill_in_and_log_in(User.last.email, "123456") }

      it "signs me in" do
        expect(page).to have_content(I18n.t("devise.sessions.signed_in"))
        expect(page).to have_css("#flash-success")
      end

      it "does not remember me after browser restart" do
        expire_cookies
        visit root_path

        expect(page).to have_link(I18n.t("buttons.log_in"), href: "/users/sign_in")
      end
    end

    context "and enter incorrect email" do
      before { fill_in_and_log_in("incorrect_user@example.com", "123456") }

      it "does not sign me in" do
        expect(page).to have_content(I18n.t("devise.failure.not_found_in_database"))
        expect(page).to have_css("#flash-error")
      end
    end

    context "and enter incorrect password" do
      before { fill_in_and_log_in(User.last.email, "incorrect_password") }

      it "does not sign me in" do
        expect(page).to have_content(I18n.t("devise.failure.invalid"))
        expect(page).to have_css("#flash-error")
      end
    end
  end

  describe "when user is not confirmed" do
    before do
      visit new_user_registration_path
      fill_in_and_sign_up("Username", "email@example.com", "123456", "123456")
      visit user_session_path
    end

    context "and logging in" do
      before { fill_in_and_log_in(User.last.email, "123456") }

      it "does not sign me in" do
        expect(page).to have_content(I18n.t("devise.failure.unconfirmed"))
        expect(page).to have_css("#flash-error")
      end
    end
  end
end
