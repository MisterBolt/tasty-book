require "rails_helper"

RSpec.describe "layouts/_navbar", type: :view do
  let(:user) { create(:user) }

  context "when user isn't logged in" do
    before { visit root_path }

    it { expect(page).to have_link(I18n.t("buttons.recipes"), class: "btn-nav", href: recipes_path) }
    it { expect(page).to have_link(I18n.t("buttons.cook_books"), class: "btn-nav", href: cook_books_path) }
    it { expect(page).to have_link(I18n.t("buttons.log_in"), class: "btn-nav", href: new_user_session_path) }
    it { expect(page).to have_link(I18n.t("buttons.sign_up"), class: "btn-nav", href: new_user_registration_path) }
    it { expect(page).not_to have_link(I18n.t("buttons.add_new_recipe")) }
    it { expect(page).not_to have_css("#dropdown_navbar") }

    it "highlight the recipes link after clicking on it" do
      find("a", text: I18n.t("buttons.recipes")).click
      expect(page).to have_link(I18n.t("buttons.recipes"), class: "btn-nav-active", href: recipes_path)
    end

    it "highlight the cook_books link after clicking on it" do
      find("a", text: I18n.t("buttons.cook_books")).click
      expect(page).to have_link(I18n.t("buttons.cook_books"), class: "btn-nav-active", href: cook_books_path)
    end

    it "highlight the login link after clicking on it" do
      find("a", text: I18n.t("buttons.log_in")).click
      expect(page).to have_link(I18n.t("buttons.log_in"), class: "btn-nav-active", href: new_user_session_path)
    end

    it "highlight the signup link after clicking on it" do
      find("a", text: I18n.t("buttons.sign_up")).click
      expect(page).to have_link(I18n.t("buttons.sign_up"), class: "btn-nav-active", href: new_user_registration_path)
    end
  end

  context "when user is logged in" do
    before do
      visit user_session_path
      fill_in_and_log_in(user.email, user.password)
      visit root_path
    end

    it { expect(page).to have_link(I18n.t("buttons.recipes"), class: "btn-nav-active", href: recipes_path) }
    it { expect(page).to have_link(I18n.t("buttons.cook_books"), class: "btn-nav", href: cook_books_path) }
    it { expect(page).not_to have_link(I18n.t("buttons.log_in"), class: "btn-nav", href: new_user_session_path) }
    it { expect(page).not_to have_link(I18n.t("buttons.sign_up"), class: "btn-nav", href: new_user_registration_path) }
    it { expect(page).to have_link(I18n.t("buttons.add_new_recipe"), class: "btn-nav", href: new_recipe_path) }
    it { expect(page).to have_css("#dropdown_navbar") }
    it { expect(page).to have_link(I18n.t("buttons.dashboard"), href: profile_index_path) }
    it { expect(page).to have_link(I18n.t("buttons.my_profile"), href: user_path(user)) }
    it { expect(page).to have_link(I18n.t("buttons.log_out"), href: destroy_user_session_path) }

    it "highlight the add new recipe link after clicking on it" do
      find("a", text: I18n.t("buttons.add_new_recipe")).click
      expect(page).to have_link(I18n.t("buttons.add_new_recipe"), class: "btn-nav-active", href: new_recipe_path)
    end
  end
end
