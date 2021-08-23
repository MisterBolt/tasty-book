require "rails_helper"

RSpec.describe "update user data process", type: :feature do
  let(:user) { create(:user, username: "oldUsername", password: "oldPassword") }

  context "when user changes avatar" do
    let!(:old_avatar) { user.check_avatar }
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      attach_file("user_avatar", Rails.root + "spec/fixtures/files/cook.png")
      find("#change_avatar").click
    end

    it { expect(page).to have_css("#flash-success", text: I18n.t("profile.update_avatar.notice")) }
    it { expect(user.reload.check_avatar).not_to eq(old_avatar) }
  end

  context "when user tries to change avatar with invalid data" do
    let!(:old_avatar) { user.check_avatar }
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      attach_file("user_avatar", Rails.root + "spec/fixtures/files/empty_text.txt")
      find("#change_avatar").click
    end

    it { expect(page).to have_css("#flash-error") }
    it { expect(user.reload.check_avatar).to eq(old_avatar) }
  end

  context "when user changes username" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      fill_in("user_username", with: "newUsername")
      find("#change_username").click
    end

    it { expect(page).to have_css("#flash-success", text: I18n.t("profile.update_username.notice")) }
    it { expect(user.reload.username).to eq("newUsername") }
    it { expect(page.find("#user_username")["value"]).to have_content("newUsername") }
  end

  context "when user tries to change username with invalid data" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      fill_in("user_username", with: "  ")
      find("#change_username").click
    end

    it { expect(page).to have_css("#flash-error") }
    it { expect(user.reload.username).to eq("oldUsername") }
  end

  context "when user changes password" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      fill_in("user_password", with: "newPassword")
      fill_in("user_password_confirmation", with: "newPassword")
      fill_in("user_current_password", with: "oldPassword")
      find("#change_password").click
    end

    it { expect(page).to have_css("#flash-success", text: I18n.t("profile.update_password.notice")) }
    it { expect(user.reload.valid_password?("newPassword")).to be(true) }
  end

  context "when user tries to change password with invalid data" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit settings_profile_index_path
      fill_in("user_password", with: "newPassword")
      fill_in("user_password_confirmation", with: "newWrongPassword")
      fill_in("user_current_password", with: "oldPassword")
      find("#change_password").click
    end

    it { expect(page).to have_css("#flash-error") }
    it { expect(user.reload.valid_password?("oldPassword")).to be(true) }
  end
end
