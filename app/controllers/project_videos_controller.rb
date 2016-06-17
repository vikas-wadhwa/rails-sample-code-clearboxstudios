class ProjectVideosController < ApplicationController


  ########################################################
  # Setup helpers/plugins
  ########################################################
  autocomplete :credit, :title
  autocomplete :profile, :name_first,
               :display_value => :full_name,
               :extra_data => [:user_id],
               :full_model => true,
               :extra_methods => {'image_url' => 'tiny'},
               :scopes_only => true,
               :scopes => [[:search_by_name, :term]]



  ########################################################
  # define new video object
  ########################################################
  def new

    @project = Project.user_readable(current_user, params[:project_id])

    if @project

      @video = @project.videos.new
      @video.set_defaults
      @aws_signature_url = root_url + "signatures/aws_uploads"

      respond_to do |format|
        format.html
        format.json  { render :json => {:video_id => @video.id, :aws_videos_path => @video.videos_path}, :status => :ok }
      end

    else
      not_authorized
    end

  end


  ########################################################
  # Edit existing video attributes
  ########################################################
  def edit

    @project = Project.user_readable(current_user, params[:project_id])

    if @project

      @video = @project.videos.find(params[:id])
      @aws_signature_url = root_url + "signatures/aws_uploads"
      respond_to do |format|
        format.html
        format.json  { render :json => {:video_id => @video.id, :aws_videos_path => @video.videos_path}, :status => :ok }
      end

    else
      not_authorized
    end



  end


  ########################################################
  # take incoming POST video, save, and set as profile
  ########################################################
  def create


    @project = Project.user_readable(current_user, params[:project_id])

    if @project

      @video = @project.videos.new(params[:project_video])

      if @video.save
        respond_to do |format|
          format.json  { render :json => {:video_id => @video.id, :aws_videos_path => @video.videos_path}, :status => :ok }
        end

      else
        respond_to do |format|
          format.json { render json: @video.errors, status: :unprocessable_entity }
        end
      end

    else
      not_authorized
    end



  end


  ########################################################
  # Update to set default demo reel
  ########################################################  
  def update


    @project = Project.user_readable(current_user, params[:project_id])

    if @project

      @video = @project.videos.find(params[:id])

      if @video.update(params[:project_video])
        respond_to do |format|
          format.json  { render :json => {:video_id => @video.id,
                                          :aws_videos_path => @video.videos_path}, :status => :ok }
        end

      else
        respond_to do |format|
          format.json { render json: @video.errors, status: :unprocessable_entity }
          #format.html  { render action: "edit" }
        end
      end


    else
      not_authorized
    end





  end


  ########################################################
  # take incoming POST video details
  ########################################################
  def attach_video

    @video = ProjectVideo.find_by_id(params[:video_id])
    @project = Project.user_readable(current_user, @video.project)


    if @project

      #for plupload rename "file" to expected "video[data]"

      if(params[:file])
        params[:project_video_file] = params[:file]
      end

      ########################################################
      # find the current video and remove if exists
      ########################################################
      @video = @project.videos.find(params[:video_id]) || @project.videos.new
      @video.video = nil
      @video.save

      ########################################################
      # save new attachment details
      ########################################################
      @video[:video_file_name] = params[:project_video_file][:name]
      @video[:video_content_type] = params[:project_video_file][:content_type]
      @video[:video_file_size] = params[:project_video_file][:size]
      @video[:video_updated_at] = DateTime.now


      if @video.save
        respond_to do |format|
          format.json  { render :json => [video_gallery_item_id: @video.id,
                                          video_player_url: @video.url(:mp4)
                                              ],
                                :status => :ok }
        end

      else
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => @video.errors, :status => :unprocessable_entity }
        end
      end

    else
      not_authorized
    end




  end


  ########################################################
  # take incoming POST picture, save, and set as demo image link
  ########################################################
  def attach_image

    @video = ProjectVideo.find_by_id(params[:video_id])
    @project = Project.user_readable(current_user, @video.project)

    if @project


      #for plupload rename "file" to expected "video[data]"
      if(params[:file])
        params[:project_video_image] = params[:file]
      end




      begin

        if @video.update(:image=>params[:project_video_image])

          respond_to do |format|
            format.json  { render :json => [video_gallery_item_id: @video.id,
                                            refresh_photo_url: @video.image.url(:medium)
                                              #video_gallery_item: view_context.video_gallery_item(@video)],
                                              ],
                                  :status => :ok
            }
          end

        else
          respond_to do |format|
            #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
            format.json  { render :json => [:error_message => 'Wrong filetype, please upload JPG or PNG only.'], :status => :ok }
          end

        end

      rescue Paperclip::Errors::NotIdentifiedByImageMagickError
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => [:error_message => 'Wrong filetype, please upload JPG or PNG only.'], :status => :ok }
        end
      end


    else
      not_authorized
    end


  end


  ########################################################
  # Custom crop a user video image
  ########################################################  
  def crop

    @project = Project.user_readable(current_user, params[:project_id])

    if @project

      @video = @project.videos.find(params[:photo_to_crop_id])
      @video.crop_x = params[:coordinates][:crop_x].to_i.to_s
      @video.crop_y = params[:coordinates][:crop_y].to_i.to_s
      @video.crop_w = params[:coordinates][:crop_w].to_i.to_s
      @video.crop_h = params[:coordinates][:crop_h].to_i.to_s

      if @video.image.reprocess!
        respond_to do |format|
          format.json  { render :json => [:project_video_id => @video.id,
                                          refresh_photo_url: @video.image(:medium)
                                           ],
                                :status => :ok }
        end

      else
        respond_to do |format|
          format.json  { render :json => @video.errors, :status => :unprocessable_entity }
        end
      end

    else
      not_authorized
    end

  end



  ########################################################
  # Delete a user video
  ########################################################
  def destroy


    @project = Project.user_editable(current_user, params[:project_id])

    if @project

      @video = @project.videos.find(params[:id])
      @video.image.destroy

      if @video.destroy
        respond_to do |format|
          format.json  { render :json => [:id=>@video.id], :status => :ok }
        end

      else
        respond_to do |format|
          format.json  { render :json => @video.errors, :status => :unprocessable_entity }
        end

      end

    else
      not_authorized
    end

  end


end