class AutomatedPassword < ActionMailer::Base

  helper :email
  default from: "Clearbox Accounts"
  
  def notify_users(user, password, subject)

    @user = user
    @password= password
    @subject = subject
    @delivery_options = { user_name: CORPORATE_LOGINS[:gmail_accounts][:username],
                          password: CORPORATE_LOGINS[:gmail_accounts][:password]
                        }

    mail to: @user.email, subject: @subject, delivery_method_options: @delivery_options

  end


end
