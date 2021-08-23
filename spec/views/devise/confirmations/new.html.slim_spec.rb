require "rails_helper"

RSpec.describe "devise/confirmations/new", type: :view do
  before do
    visit new_user_confirmation_path
  end

  it { expect(page).to have_field("user_email", type: "email") }
  it { expect(page).to have_css("input", id: "resend_confirmation") }
  it { expect(page).to have_content(I18n.t("all_rights")) }
end
