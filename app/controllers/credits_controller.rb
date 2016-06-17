class CreditsController < ApplicationController


  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!





  ################################################
  # Autocomplete searching for credits
  ################################################
 
  def autocomplete
  
    @credits = Credit.select([:id, :department, :credit]).where("credit ILIKE ? ", "%#{params[:filter]}%" ).limit(params[:limit])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @credits }
      format.js
      format.json { render :json => @credits }
    end


  end


end
