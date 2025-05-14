class PostmanMailer < ApplicationMailer
  def login_account
    mail(to: "example@gmail.com", subject: ("you have successfully logged to your account"))
  end
end
