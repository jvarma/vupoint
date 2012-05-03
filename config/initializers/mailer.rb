ActionMailer::Base.smtp_settings = {  
  :address              => "smtp.gmail.com",  
  :port                 => 587,  
  :domain               => "vupnt.herokuapp.com",  
  :user_name            => "izebrg",  
  :password             => "scorpio1971",  
  :authentication       => "plain",  
  :enable_starttls_auto => true  
} 