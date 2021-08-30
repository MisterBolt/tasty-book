require "rails_helper"

RSpec.describe "profile/index", type: :view do
  let(:user) { create(:user) }

  context "when user is not signed in" do
    before { visit profile_index_path }

    it { expect(current_path).to eql(new_user_session_path) }
  end

  context "when user has default statistics" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit profile_index_path
    end

    it { expect(current_path).to eql(profile_index_path) }
    it { expect(page).to have_css("a.current", text: t("profile.sidebar.dashboard")) }
    it { expect(page).to have_css("#dashboard_username", text: user.username) }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.followers").parameterize.underscore}", text: "0") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.following").parameterize.underscore}", text: "0") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.from_you").parameterize.underscore}", text: "0") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.for_you").parameterize.underscore}", text: "0") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.your_recipes_in_tasty_books").parameterize.underscore}", text: "0") }
    it { expect(page).to have_css("#dashboard_recipes", text: "0") }
    it { expect(page).to have_css("#dashboard_drafts", text: "0") }
    it { expect(page).not_to have_css("#dashboard_recipes_percent") }
    it { expect(page).not_to have_css("#dashboard_drafts_percent") }
    it { expect(page).not_to have_css("#dashboard_score") }
    it { expect(page).to have_css("#dashboard_cook_books", text: "") }
  end

  context "when user increases his statistics" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      create_list(:follow, 3, followed_user: user)
      create(:follow, follower: user)
      create(:comment, user: user)
      recipe = create(:recipe, user: user)
      other_recipe = create(:recipe, user: user)
      create(:comment, recipe: recipe)
      create(:recipe_score, recipe: recipe, score: 4)
      create(:recipe_score, recipe: other_recipe, score: 2)
      cook_book = create(:cook_book, user: user)
      cook_book.recipes << recipe
      visit profile_index_path
    end

    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.followers").parameterize.underscore}", text: "3") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.following").parameterize.underscore}", text: "1") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.from_you").parameterize.underscore}", text: "1") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.for_you").parameterize.underscore}", text: "1") }
    it { expect(page).to have_css("#dashboard_#{I18n.t("profile.index.your_recipes_in_tasty_books").parameterize.underscore}", text: "1") }
    it { expect(page).to have_css("#dashboard_recipes", text: "2") }
    it { expect(page).to have_css("#dashboard_recipes_percent", text: "100%") }
    it { expect(page).to have_css("#dashboard_drafts_percent", text: "") }
    it { expect(page).to have_css("#dashboard_score", text: "3.0") }
    it { expect(page).to have_css("#dashboard_cook_books", text: "2") }
  end
end
