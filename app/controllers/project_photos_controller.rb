class ProjectPhotosController < ApplicationController


  ########################################################
  # take incoming POST picture, save, and set as project
  ########################################################
  def create

    #for plupload rename "file" to expected "photo[data]"  
    if(params[:file])
      params[:project_photo] = params[:file]
    end

    @project = Project.user_editable(current_user, params[:project_id])

    if @project

      @project_photo = @project.photos.create(:image=>params[:project_photo])


      if @project_photo.save

        if @project.image_links= {}
          @image_links = {:project_image => @project_photo.id}
          @project.image_links = @image_links
          @project.save
        end

        respond_to do |format|
          format.json  { render :json => [:photo_gallery_item_id => @project_photo.id, :photo_gallery_item => view_context.image_gallery_item(@user_photo, 'editable')], :status => :ok }
        end

      else
        respond_to do |format|
          format.html  { redirect_to(edit_project_url(@project), :notice => 'There was an issue with photo upload. Please try again') }
          format.json  { render :json => @project.errors, :status => :unprocessable_entity }
        end
      end

    else
      not_authorized
    end



  end



  def update


    @project = Project.user_editable(current_user, params[:project_id])

    if @project
      @image_links = {:project_image => params[:new_id]}
      @project.image_links = @image_links

      @original = @project.photos.find(params[:new_id]).image.url(:original)
      @cropped = @project.photos.find(params[:new_id]).image.url(:medium)


      if @project.save
        respond_to do |format|
          format.json  { render :json => [:original=>@original, :cropped=>@cropped], :status => :ok }
        end

      else
        respond_to do |format|
          format.json  { render :json => @project.errors, :status => :unprocessable_entity }
        end

      end

    else
      not_authorized
    end

  end



  def crop

    @project_photo_id = params[:original_photo_id]
    @project = Project.user_editable(current_user, params[:project_id])

    if @project
      @project_photo = @project.photos.find(@project_photo_id)
      @project_photo.crop_x = params[:coordinates][:crop_x].to_i.to_s
      @project_photo.crop_y = params[:coordinates][:crop_y].to_i.to_s
      @project_photo.crop_w = params[:coordinates][:crop_w].to_i.to_s
      @project_photo.crop_h = params[:coordinates][:crop_h].to_i.to_s

      if @project_photo.image.reprocess!
        respond_to do |format|
          format.json  { render :json => [:project_photo_id=>@project_photo_id], :status => :ok }
        end

      else
        respond_to do |format|
          format.json  { render :json => @project.errors, :status => :unprocessable_entity }
        end

      end

    else
      not_authorized
    end

  end


  def destroy

    @id = params[:id]

    @project = Project.user_editable(current_user, params[:project_id])

    if @project


      @project_photo = @project.photos.find(@id)
      @project_photo.image.destroy

      if @project_photo.destroy
        respond_to do |format|
          format.json  { render :json => [:id=>@id], :status => :ok }
        end

      else
        respond_to do |format|
          format.json  { render :json => @project.errors, :status => :unprocessable_entity }
        end

      end

    else
      not_authorized
    end

  end


end