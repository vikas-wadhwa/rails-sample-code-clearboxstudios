class Admin::DashboardController < ApplicationController


  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!, :must_be_admin


  def index

  end


  def update

    emails = params[:user_emails].split(/\s*[,;]\s* # comma or semicolon, optionally surrounded by whitespace
    |           # or
    \s{2,}      # two or more whitespace characters
    |           # or
    [\r\n]+     # any number of newline characters
    /x)


    subject = params[:email_subject]


    if params[:type] == "notify_users"



      emails.each do |email|
        user = User.find_by_email(email.strip.downcase)

        # generate password if the user has never signed in, used for batch-created users
        unless user.last_sign_in_at
          passCode = Devise.friendly_token.first(8)
          user.password = passCode
          user.password_confirmation = passCode
          user.save!
        end

        AutomatedPassword.notify_users(user, passCode, subject).deliver

      end

    else

    end

    respond_to do |format|
      format.html { redirect_to admin_dashboard_url, notice: 'Emails Sent' }
      format.json { render json: admin_dashboard_url, status: :created}
    end

  end


  private

  def must_be_admin
    unless current_user && current_user.profile.staff_member?
      not_authorized
    end
  end

end
