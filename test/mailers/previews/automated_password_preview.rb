# Preview all emails at http://localhost:3000/rails/mailers/automated_password
class AutomatedPasswordPreview < ActionMailer::Preview

  def notify_users_preview
    userVik = User.find_by_email('vikas.wadhwa@clearboxstudios.com')
    AutomatedPassword.notify_users(userVik, 'temporary1', 'Your headshots are now available.')
  end

end
