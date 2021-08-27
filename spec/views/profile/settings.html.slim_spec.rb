require "rails_helper"

RSpec.describe "profile/settings", type: :view do
  let(:user) { create(:user) }

  context "when user is not signed in" do
    before { visit settings_profile_index_path }

    it { expect(current_path).to eq(new_user_session_path) }
  end

  context "when user is signed in" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
    end

    it { expect(current_path).to eq(settings_profile_index_path) }
    it { expect(page.find("#user_avatar_image")["src"]).to match(/^.*\.(jpeg|png)$/) }
    it { expect(page).to have_css(".input-file") }
    it { expect(page.find("#user_username")["value"]).to have_content(user.username) }
    it { expect(page.find("#user_password")["placeholder"]).to have_content(I18n.t("profile.settings.new_password")) }
    it { expect(page.find("#user_password_confirmation")["placeholder"]).to have_content(I18n.t("profile.settings.confirm_new_password")) }
    it { expect(page.find("#user_current_password")["placeholder"]).to have_content(I18n.t("profile.settings.current_password")) }
    it { expect(page).to have_link(I18n.t("profile.settings.delete_account_with_related_data"), href: "/profile/delete_user_with_data") }
  end
end
