require "rails_helper"

RSpec.describe "users/_user", type: :view do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    visit user_session_path
    fill_in_and_log_in(user.email, user.password)
    visit user_path(other_user)
  end

  it "displays user image" do
    expect(page).to have_css("img", id: "user-image", count: 1)
  end

  it "displays user name with link to profile" do
    expect(page).to have_link(other_user.username, href: user_path(other_user))
  end

  it "displays \"follows/_stats\" partial" do
    expect(page).to have_css("div", id: "follows-stats")
  end

  it "displays number of recipes user owns" do
    expect(page).to have_content(I18n.t("users.recipes_count", count: other_user.recipes.count))
  end

  context "when user not following other user" do
    it { expect(page).to have_button(I18n.t("follows.create.action")) }
  end

  context "when user already following other user" do
    before do
      user.follow(other_user)
      visit user_path(other_user)
    end

    it { expect(page).to have_button(I18n.t("follows.destroy.action")) }
  end

  context "when user is on self profile" do
    before { visit user_path(user) }

    it { expect(page).not_to have_button(I18n.t("follows.create.action")) }
    it { expect(page).not_to have_button(I18n.t("follows.destroy.action")) }
  end
end
