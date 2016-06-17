class NewsLetter < ActionMailer::Base

  helper :email
  default from: CORPORATE_LOGINS[:gmail_accounts][:username]


end
