require "rails_helper"

RSpec.describe "registration process", type: :feature do
  before { visit new_user_registration_path }

  context "filling in correct data" do
    it "saves user in database" do
      expect {
        fill_in_and_sign_up("Username", "email@example.com", "123456", "123456")
      }.to change(User, :count).by(1)
    end
  end

  context "leaving fields empty" do
    before { fill_in_and_sign_up("", "", "", "") }

    it "displays error" do
      expect(page).to have_content("can't be blank")
    end
  end

  context "filling in too short password" do
    before { fill_in_and_sign_up("Username", "email@example.com", "1", "1") }

    it "displays error" do
      expect(page).to have_content("Password is too short")
    end
  end

  context "filling in wrong password confirmation" do
    before { fill_in_and_sign_up("Username", "email@example.com", "123456", "654321") }

    it "displays error" do
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end

  context "filling in taken username" do
    before { create(:user) }
    before { fill_in_and_sign_up(User.last.username, "email@exmaple.com", "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Username has already been taken")
    end
  end

  context "filling in taken email" do
    before { create(:user) }
    before { fill_in_and_sign_up("Username", User.last.email, "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Email has already been taken")
    end
  end
end
