class UserMailer < ActionMailer::Base
  default from: "izebrg@gmail.com"

  def confirm_email(user)
  	@user = user
  	mail(to: user.email, subject: "Your view counts! Please confirm your email id.")
  end
end
