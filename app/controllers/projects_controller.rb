class ProjectsController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!




  ################################################
  # GET /projects
  # GET /projects.json
  ################################################

  def index

    results = Project.includes(:images, :videos, :account, :invoice).user_readable(current_user)

    respond_to do |format|

      if results.size == 1
        @project = results.first
        format.html { redirect_to project_url(@project)}

      else
        @projects = results.page(params[:page]).per(@@results_per_page)
        format.html # index.html.erb
      end

    end

  end


  ################################################
  # GET /projects/1
  # GET /projects/1.json
  ################################################

  def show

    @project = Project.includes(:account, :images, :videos, :invoice).user_readable(current_user, params[:id])

    if @project

      begin
        @photos = []
        @videos = []

        if @project.user_editable(current_user)

          @video_player_type = 'editable'
        else

          @video_player_type = 'playable'
        end

        if @project.invoice.nil?
          @invoice = false
        else
          @invoice = @project.invoice.user_readable(current_user)
        end


      rescue
        @media_by_project = {}
        network_error
      end

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @project }
      end

    else
      not_authorized
    end


  end



  ################################################
  # GET /projects/new
  # GET /projects/new.json
  ################################################

  def new

    @original_project_id = ''
    @accounts =  []

    if Account.user_readable(current_user).any?

      if params[:original_project_id]
        @original_project = Project.user_readable(current_user, params[:original_project_id])
        @project = @original_project.dup

        @accounts << @project.account
        @accounts = @accounts +  Account.user_readable(current_user)
        @accounts.reverse!
        @accounts.uniq!
        @accounts.reverse!

      elsif params[:account_id]
        @account = Account.user_readable(current_user, params[:account_id])
        @project = @account.projects.new

        @accounts << @project.account
        @accounts = @accounts +  Account.user_readable(current_user)
        @accounts.reverse!
        @accounts.uniq!
        @accounts.reverse!

      else
        @project = Project.new
        @accounts =  Account.user_readable(current_user)

      end


      respond_to do |format|
        format.html # edit.html.erb
        format.json { render json: @project }
      end

    else

      respond_to do |format|
        format.html { redirect_to new_account_url, notice: 'Please create a billable account first.' }
      end

    end


  end



  ################################################
  # GET /projects/1/edit
  ################################################

  def edit

    @project = Project.user_readable(current_user, params[:id])

    if @project
      @accounts =  []
      @accounts << @project.account
      @accounts = @accounts +  Account.user_readable(current_user)
      @accounts.reverse!
      @accounts.uniq!
      @accounts.reverse!

    else
      not_authorized
    end

  end


  ################################################
  # POST /projects
  # POST /projects.json
  ################################################

  def create

    ## Format the date/time, otherwise the incoming values are ignored during update throw validation errors
    params[:project][:start]= Date.strptime(params[:project][:start], '%m-%d-%Y')
    params[:project][:end]= Date.strptime(params[:project][:end], '%m-%d-%Y')

    @original_project = Project.user_editable(current_user, params[:original_project_id]) if params[:original_project_id]
    @project = Project.new(params[:project])

    respond_to do |format|

      if @original_project && @project.save && @project.create_duplicate_tasks(@original_project)
        format.html { redirect_to project_url(@project), notice: 'Project "' + @project.title + '" was successfully created.' }
        format.json { render json: project_url(@project), status: :created, location: @project }

      elsif @project.save && @project.create_default_tasks
        format.html { redirect_to project_url(@project), notice: 'Project "' + @project.title + '" was successfully created.' }
        format.json { render json: project_url(@project), status: :created, location: @project }

      else
        @accounts = Account.user_readable(current_user)
        format.html { render action: "new"}
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  ################################################
  # PUT /projects/1
  # PUT /projects/1.json
  ################################################

  def update

    @project = Project.user_editable(current_user, params[:id])

    ## Format the date/time, otherwise the incoming values are ignored during update throw validation errors
    params[:project][:start]= Date.strptime(params[:project][:start], '%m-%d-%Y')
    params[:project][:end]= Date.strptime(params[:project][:end], '%m-%d-%Y')


    if @project
      respond_to do |format|

        if @project.update(params[:project])
          format.html { redirect_to project_url(@project), notice: 'Project "' + @project.title + '" was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end

      end

    else
      not_authorized
    end

  end


  ################################################
  # POST /projects
  # POST /projects.json
  ################################################

  def search

    @searching = true
    results = Project.includes(:images, :videos, :account, :invoice).user_readable(current_user).search_for(params['search-string'])
    @projects = results.page(params[:page]).per(@@results_per_page)

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @project.errors, status: :unprocessable_entity }
    end

  end


  ################################################
  # DELETE /projects/media
  # DELETE /projects.json
  ################################################
  def delete_media

    @asset = Asset.find(params[:id])
    @asset.destroy
    flash[:notice] = "Project files have been deleted"

    respond_to do |format|
      format.html { redirect_to @project, notice: 'Files have been deleted.' }
    end

  end



  ################################################
  # DELETE /projects/1
  # DELETE /projects/1.json
  ################################################

  def destroy

    @project = Project.find(params[:id])
    @project.destroy if @project.destroyable? && Project.user_editable(current_user).include?(@project)
    account_param = {:account_id=> params[:account_id]} unless params[:account_id].nil?

    respond_to do |format|
      format.html { redirect_to projects_url(account_param) }
      format.json { head :no_content }
    end

  end







  private


  ################################################
  # Class Variables
  ################################################


  def find_media(projects)

    begin

      media_by_project = {}

      projects.each do |project|

        src_url = project.image_url(:medium)
        download_url = project.image_url(:medium)


        @bucket_objects = project.bucket_objects('documents')
        bucket_count = @bucket_objects.count
        @bucket_objects.each do |object|

          if object.content_type.split("/").first == 'image'
            src_url = object.url_for(:read, secure: true, expires: 90.minutes).to_s
            download_url = object.url_for(:read, secure: true, expires: 90.minutes, response_content_disposition: 'attachment;').to_s
            break
          end
        end


        media_by_project[project]= {count: bucket_count, src_url: src_url, download_url: download_url}

      end

    rescue
      network_error
    end


    return media_by_project

  end







end
