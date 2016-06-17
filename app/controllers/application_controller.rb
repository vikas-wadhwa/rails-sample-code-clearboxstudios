class ApplicationController < ActionController::Base

  protect_from_forgery
  before_filter :initialize_variables
  after_action :allow_x_frames



  ################################################
  # define rescue_from mappings
  ################################################
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from AWS::Core::Client::NetworkError, :with => :network_error
  #rescue_from User::NotAuthorized, :with => :not_authorized


  def initialize_variables
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  ################################################
  # Devise routing
  ################################################

  #def after_sign_in_path_for(resource)
  #  current_user_path
  #end

  def after_inactive_sign_up_path_for(resource)
    sign_ins_path
  end

  def after_sign_up_path_for(resource)
    request.referrer
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end



  private

  def configure_aws_s3(model)
    S3DirectUpload.config do |c|
      c.bucket = model.media_bucket
    end
  end

  def allow_x_frames
    response.headers['X-Frame-Options'] = 'ALLOW-FROM https://www.responsinator.com'
  end


  ################################################
  # Global search results limit
  ################################################
  @@results_per_page = 10


  ################################################
  # define generic error functions
  ################################################
  def network_error
    flash[:error] = "An issue with network traffic prevented your page from loading fully. Please try again."
  end

  def not_found
    flash[:error] = "The information you requested was not found."
  end

  def not_authorized
    flash[:error] = "You don't have access to the requested page."
    redirect_to dashboard_url
  end

end
