require "rails_helper"

RSpec.describe "registration process", type: :feature do
  before { visit new_user_registration_path }

  context "filling in correct data" do
    subject { fill_in_and_sign_up("Username", "email@example.com", "123456", "123456") }

    it "saves user in database" do
      expect { subject }.to change(User, :count).by(1)
    end

    it "user has got attached resized avatar photo" do
      subject
      User.last.avatar.analyze
      expect(User.last.avatar).to be_attached
      expect(User.last.avatar.metadata[:width]).to eq(150)
      expect(User.last.avatar.metadata[:height]).to eq(150)
      expect(User.last.avatar.content_type.starts_with?("image/")).to eq(true)
    end

    it "sends the user an email" do
      subject
      expect(Devise.mailer.deliveries.count).to eq(1)
    end

    it "displays flash success" do
      subject
      expect(page).to have_content(I18n.t("devise.registrations.signed_up_but_unconfirmed"))
      expect(page).to have_css("#flash-success")
    end
  end

  context "leaving avatar file upload field empty" do
    subject { fill_in_and_sign_up("Username", "email@example.com", "123456", "123456", nil) }

    it "saves user in database" do
      expect { subject }.to change(User, :count).by(1)
    end

    it "user hasn't got attached avatar photo" do
      subject
      expect(User.last.avatar).not_to be_attached
    end
  end

  context "trying to upload not image file for avatar" do
    subject { fill_in_and_sign_up("Username", "email@example.com", "123456", "123456", "#{Rails.root}/spec/files/avatar.txt") }

    it "doesn't save user in database" do
      expect { subject }.not_to change(User, :count)
    end

    it "displays error" do
      subject
      expect(page).to have_content("Avatar needs to be an image")
    end
  end

  context "leaving fields empty" do
    before { fill_in_and_sign_up("", "", "", "") }

    it "displays error" do
      expect(page).to have_content("can't be blank")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in too short password" do
    before { fill_in_and_sign_up("Username", "email@example.com", "1", "1") }

    it "displays error" do
      expect(page).to have_content("Password is too short")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in wrong password confirmation" do
    before { fill_in_and_sign_up("Username", "email@example.com", "123456", "654321") }

    it "displays error" do
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in taken username" do
    before { create(:user) }
    before { fill_in_and_sign_up(User.last.username, "email@exmaple.com", "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Username has already been taken")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in username with 'Guest'" do
    before { fill_in_and_sign_up("Guest", "email@exmaple.com", "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Username can't be 'Guest'")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in username starting with 'Deleted_user'" do
    before { fill_in_and_sign_up("Deleted_user12", "email@exmaple.com", "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Username can't be 'Deleted_user'")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end

  context "filling in taken email" do
    before { create(:user) }
    before { fill_in_and_sign_up("Username", User.last.email, "123456", "123456") }

    it "displays error" do
      expect(page).to have_content("Email has already been taken")
    end

    it "does not send the user an email" do
      expect(Devise.mailer.deliveries.count).to eq(0)
    end
  end
end
