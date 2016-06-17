class RegistrationsController < Devise::RegistrationsController
  protected
  def after_inactive_sign_up_path_for(resource)

    # store message to be displayed after redirection to login screen
    session[:registration_flash] = flash[:notice] if flash[:notice]
    new_user_session_path

  end
end 