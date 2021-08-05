require "rails_helper"

RSpec.describe "follows/_stats", type: :view do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    visit user_session_path
    fill_in_and_log_in(user.email, user.password)
    visit user_path(user)
  end

  context "when user have no followings and no followers" do
    it { expect(page).to have_link(I18n.t("follows.followings.other", count: 0), href: followings_user_path(user)) }
    it { expect(page).to have_link(I18n.t("follows.followers.other", count: 0), href: followers_user_path(user)) }
  end

  context "when user have 1 following and 1 follower" do
    before do
      user.follow(other_user)
      other_user.follow(user)
      visit user_path(user)
    end

    it { expect(page).to have_link(I18n.t("follows.followings.one"), href: followings_user_path(user)) }
    it { expect(page).to have_link(I18n.t("follows.followers.one"), href: followers_user_path(user)) }
  end

  context "when user have 2 followings and 2 followers" do
    let(:other_user_2) { create(:user) }

    before do
      user.follow(other_user)
      other_user.follow(user)
      user.follow(other_user_2)
      other_user_2.follow(user)
      visit user_path(user)
    end

    it { expect(page).to have_link(I18n.t("follows.followings.other", count: 2), href: followings_user_path(user)) }
    it { expect(page).to have_link(I18n.t("follows.followers.other", count: 2), href: followers_user_path(user)) }
  end
end
