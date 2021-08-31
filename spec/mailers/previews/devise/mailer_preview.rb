module Devise
  class MailerPreview < ActionMailer::Preview
    def confirmation_instructions
      Devise::Mailer.confirmation_instructions(User.first, "fake_token")
    end

    def reset_password_instructions
      Devise::Mailer.reset_password_instructions(User.first, "fake_token")
    end
  end
end
