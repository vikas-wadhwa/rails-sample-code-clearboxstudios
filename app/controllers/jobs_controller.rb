class JobsController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!




  ################################################
  # GET /jobs
  # GET /jobs.json
  ################################################

  def index
  
  end


  ################################################
  # GET /jobs/1
  # GET /jobs/1.json
  ################################################

  def show

  end



  ################################################
  # GET /jobs/new
  # GET /jobs/new.json
  ################################################

  def new

   
  end



  ################################################
  # GET /jobs/1/edit
  ################################################

  def edit

  end



  ################################################
  # POST /jobs
  # POST /jobs.json
  ################################################

  def create

  end


  ################################################
  # PUT /jobs/1
  # PUT /jobs/1.json
  ################################################

  def update


  end


  ################################################
  # POST /jobs
  # POST /jobs.json
  ################################################

  def search

    @jobs = []
    
    PgSearch.multisearch(params['search-string']).where(:searchable_type => "Job").find_each do |document|
      @jobs << document.searchable
    end

    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
    end
    
  end


  ################################################
  # DELETE /jobs/1
  # DELETE /jobs/1.json
  ################################################

  def destroy

  end
end
