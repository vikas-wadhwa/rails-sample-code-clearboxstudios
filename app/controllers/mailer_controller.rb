class MailerController < ApplicationController

  def contact_us

    @email = ContactUsMailer.website_form(params).deliver

    if @email

      response = @email.to_json

      respond_to do |format|
        format.json { render json: response }
      end


    end

  end


end
