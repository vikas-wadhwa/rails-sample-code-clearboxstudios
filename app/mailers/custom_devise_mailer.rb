
class CustomDeviseMailer < Devise::Mailer

  helper :email # gives access to all helpers defined within `email_helper`.

  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

end