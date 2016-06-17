class ContactUsMailer < ActionMailer::Base

  helper :email
  default from: 'Clearbox Website Emailer'


  def website_form(params)

    @details = params.except('controller').except('action')
    @to = 'vikas.wadhwa@clearboxstudios.com'
    @subject = 'INFO REQUESTED'
    @subject += ' -- FROM ' + @details['name'] if @details['name']

    @delivery_options = { user_name: CORPORATE_LOGINS[:gmail_webadmin][:username],
                          password: CORPORATE_LOGINS[:gmail_webadmin][:password]
    }

    mail to: @to, subject: @subject, details: @details, delivery_method_options: @delivery_options

  end




end
