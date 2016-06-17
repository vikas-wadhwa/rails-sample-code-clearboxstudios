class ProfilesController < ApplicationController



  ################################################
  # Filters
  ################################################
  before_filter :authenticate_user!,  :except => [:index, :show]
  before_filter :profile_filled_out,  :except => [:edit]


  def profile_filled_out

      unless current_user.profile.filled_out?

        @modal = {}
        @modal[:title] = "Hi there!<br>We need more info..."
        @modal[:message] = "We're so glad you've joined our community. But you'll need to fill out the following information to show up on professional searches: "

        @modal[:list] = []
        sections = ["First Name", "Last Name", "Description"]

        sections.each_with_index  do |item, index|
          @modal[:list][index] = item.to_s
        end

        @modal[:followup] = "So head on over to " + view_context.link_to('Edit Profile', edit_profile_url(current_user.profile, anchor: "about"),  class:'orange underlined-links').to_s + " and get started."
        flash.now[:modal] = @modal

      end

  end


  ################################################
  # GET /profiles/
  ################################################

  def index

    results = Profile.joins(:user).includes(:user => [:photos]).order(created_at: :desc)
    ## on return scope of profiles that are considered filled out.
    results = results.filled_out

    # paginate results
    @profiles = results.page(params[:page]).per(@@results_per_page)

  end



  ################################################
  # GET /profiles/:id
  ################################################

  def show

    @profile = Profile.joins(:user).includes(:user => [:photos]).find(params[:id])

    if user_signed_in?
      @user_is_staff = @current_user.staff_member?
      @user_is_profile = @current_user.id == @profile.user.id
    end

    if @user_is_profile
      @video_player_type = 'editable'
    else
      @video_player_type = 'playable'
    end

    @demo_reels = {}
    @demo_reels = @profile.user.videos.where(video_type: 'Demo Reel')

    @videos_by_credit = {}
    @profile.user.credits.each do |credit|
      @videos_by_credit[credit.title] = UserVideo.joins(:credits).where('user_credits.user_id = ?', @profile.user.id).where('credits.title = ?', credit.title)
    end


  end



  ################################################
  # GET /profile/edit
  ################################################

  def edit

    @user = current_user
    @profile = current_user.profile

    if @profile == Profile.find_by_id(params[:id])

    else
      not_authorized
    end

  end



  ################################################
  # POST /profile/new
  ################################################

  def create

    @profile = current_user.build_profile(params[:profile])

    respond_to do |format|
      if @profile.save
        format.html  { redirect_to(user_root_url, notice: 'Profile was successfully created.') }
        format.json  { render :json => @profile,
                              :status => :created, :location => @profile }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @profile.errors,
                              :status => :unprocessable_entity }
      end
    end
  end




  ################################################
  # PUT /profile/edit
  ################################################

  def update


    # make sure the profile being updated is the current user's
    @profile = current_user.profile

    if @profile == Profile.find_by_id(params[:id])

      respond_to do |format|

        if @profile[:privacy_settings].merge!(params[:profile][:privacy_settings]) &&
            @profile.update(params[:profile].except(:staff_member)) &&
            @profile.save


          format.html  { redirect_to(dashboard_url, notice: 'Profile was successfully updated.') }
          format.json  { head :no_content }
        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @profile.errors,
                                :status => :unprocessable_entity }
        end
      end


    else
      not_authorized
    end

  end


  ################################################
  # PUT /profile/:id/admin_update
  ################################################
  def admin_update

    # Allow staff (specifically ID 127127)to edit whether this person is staff.
    if current_user.staff_member? && Profile.find_by_id(params[:id]).staffable?

      @profile = Profile.find_by_id(params[:id])
      @profile.staff_member = params[:profile][:staff_member]

      respond_to do |format|
        if @profile.save
          format.html  { redirect_to @profile }
          format.json  { head :no_content }

        else
          format.html  { render :action => "edit" }
          format.json  { render :json => @profile.errors,
                                :status => :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.html  { redirect_to profile_url(@profile) }
      end

    end
  end

  ################################################
  # POST /profiles
  # POST /profiles.json
  ################################################

  def search_new

    @searching = true
    results = Profile.joins(:user).includes(:user => [:photos]).user_readable(current_user).search_for(params['search-string'])
    @profiles = results.page(params[:page]).per(@@results_per_page)

    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @project.errors, status: :unprocessable_entity }
    end

  end


  def search

    results = []
    PgSearch.multisearch(params['search-string']).where(:searchable_type => "Profile").find_each do |document|
      results << document.searchable
    end

    @profiles = Kaminari.paginate_array(results).page(params[:page]).per(@@results_per_page)


    respond_to do |format|
      format.html { render action: "index" }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end

  end


  ################################################
  # POST /profiles
  # POST /profiles.json
  ################################################

  def search_rebuild

    # This section rebuilds the Kaminari search indices for Profiles through this POST request
    # Since this is a rebuild from protected data, we're allowing this POST to be unauthenticated.
    # I will revisit whether this is important to authenticate later.
    Profile.find_each { |record| record.update_pg_search_document } if current_user.staff_member?

    respond_to do |format|
      format.html { redirect_to(dashboard_url, notice: "Index rebuild for PROFILES was successful.") }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end

  end


  ################################################
  # DELETE /profile
  ################################################
  def destroy
    # Destroy is limited to when a User item is destroyed. This action should not exist on it's own.
  end



end
