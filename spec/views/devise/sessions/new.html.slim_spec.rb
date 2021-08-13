require "rails_helper"

RSpec.describe "devise/sessions/new", type: :view do
  before { visit user_session_path }

  it { expect(page).to have_field("user_email", type: "email") }
  it { expect(page).to have_field("user_password", type: "password") }
  it { expect(page).to have_field("user_remember_me", checked: false) }
  it { expect(page).to have_css("input", class: "log_in_button") }
  it { expect(page).to have_link(I18n.t("buttons.sign_up"), href: "/users/sign_up") }
  it { expect(page).to have_link(I18n.t("devise.passwords.forgot_password"), href: "/users/password/new") }
  it { expect(page).to have_content(I18n.t("all_rights")) }
end
