Devise::Mailer.class_eval do
  helper :application
  helper :email
end


###################################################
## Environment-specific parameters
###################################################

  case ENV['RAILS_ENV']

    when "development"
          ActionMailer::Base.delivery_method = :smtp
          ActionMailer::Base.smtp_settings = {
            :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'clearboxstudios.com',
            :user_name            => CORPORATE_LOGINS[:gmail_accounts][:username],
            :password             => CORPORATE_LOGINS[:gmail_accounts][:password],
            :authentication       => 'plain',
            :enable_starttls_auto => true,
            :return_response => true
          }

    when "production"
          ActionMailer::Base.delivery_method = :smtp
          ActionMailer::Base.smtp_settings = {
            :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'clearboxstudios.com',
            :user_name            => CORPORATE_LOGINS[:gmail_accounts][:username],
            :password             => CORPORATE_LOGINS[:gmail_accounts][:password],
            :authentication       => 'plain',
            :enable_starttls_auto => true,
            :return_response => true
          }
          
 
  end



