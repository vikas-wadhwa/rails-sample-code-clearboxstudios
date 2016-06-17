class TasksController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!


  ################################################
  # GET /tasks
  # GET /tasks.json
  ################################################

  def index

    if params[:project_id].nil?
      results = current_user.tasks

    else
      @project = Project.user_readable(current_user).find(params[:project_id])
      results = @project.tasks
    end

    @tasks = paginate_results(params[:page], results)
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tasks }
    end
  end



  ################################################
  # GET /tasks/1
  # GET /tasks/1.json
  ################################################

  def show

    @project = Project.user_readable(current_user).find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    respond_to do |format|
      
      if @task
        format.html # show.html.erb
        format.json { render json: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
      
    end
  end



  ################################################
  # GET /tasks/new
  # GET /tasks/new.json
  ################################################

  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @task }
    end
  end



  ################################################
  # GET /tasks/1/edit
  ################################################


  def edit
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

  end



  ################################################
  # POST /tasks
  # POST /tasks.json
  ################################################

    def create

    @project = Project.find(params[:project_id])
    @task = @project.tasks.create(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to project_url(@project, {:open_tab_index => '2'}), notice: 'Task was successfully created.' }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end



  ################################################
  # PUT /tasks/1
  # PUT /tasks/1.json
  ################################################

  def update
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    respond_to do |format|
      if @task.update(params[:task])
        format.html { redirect_to project_url(@project, {:open_tab_index => '2'}), notice: 'Task was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  ################################################
  # POST /projects
  # POST /projects.json
  ################################################

  def search

    @tasks = []
    
    PgSearch.multisearch(params['search-string']).where(:searchable_type => "Task").find_each do |document|
      @tasks << document.searchable
    end

    respond_to do |format|
        format.html { render action: "index" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
    end
    
  end

  ################################################
  # DELETE /tasks/1
  # DELETE /tasks/1.json
  ################################################

  def destroy
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    @task.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.json { head :no_content }
    end
  end
end
