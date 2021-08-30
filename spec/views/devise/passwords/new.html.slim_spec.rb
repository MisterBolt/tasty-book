require "rails_helper"

RSpec.describe "devise/passwords/new", type: :view do
  before do
    visit new_user_password_path
  end

  it { expect(page).to have_field("user_email", type: "email") }
  it { expect(page).to have_css("input", id: "reset-password") }
  it { expect(page).to have_link(I18n.t("devise.confirmations.not_receive_confirmation"), href: "/users/confirmation/new.user") }
  it { expect(page).to have_content(I18n.t("all_rights")) }
end
