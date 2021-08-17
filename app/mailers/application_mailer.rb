class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@tasty-book.com"
  layout "mailer"
end
