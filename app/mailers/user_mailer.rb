class UserMailer < ActionMailer::Base
  default from: "izebrg@gmail.com"

  def confirm_email(user)
  	@user = user
  	if Rails.env.development?
  		@host = "localhost:3000"
  	else
  		@host = "vupnt.herokuapp.com"
  	end
  	mail(to: user.email, subject: "Your view counts! Please confirm your email id.")
  end
end
