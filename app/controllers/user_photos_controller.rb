class UserPhotosController < ApplicationController




  ########################################################
  # take incoming POST picture, save, and set as profile
  ########################################################
  def create

    #for plupload rename "file" to expected "photo[data]"  
    if(params[:file])  
      params[:user_photo] = params[:file]  
    end 

    @user = current_user
    @profile = @user.profile
    @user_photo = @user.photos.create(image: params[:user_photo])

    begin    

      if @user_photo.save

        unless @profile.image_links.has_key?(:profile_image)
          @profile.image_links.merge!(profile_image: @user_photo.id)
          @profile.save
        end

        respond_to do |format|
          format.json  { render :json => [:photo_gallery_item_id => @user_photo.id, :refresh_photo_url => @user_photo.image.url(:large), :photo_gallery_item => view_context.image_gallery_item(@user_photo, 'editable')], :status => :ok }
        end

      else
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => [:error_message => 'conversion failure'], :status => :ok }
        end
      end    
    
    rescue Paperclip::Errors::NotIdentifiedByImageMagickError
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => [:error_message => 'cannot convert filetype'], :status => :ok }
        end    
    end

  end
  
  
  
  def update
  
    
    @user = current_user
    @profile = @user.profile
    @image_links = {:profile_image => params[:new_id]}
    @profile.image_links = @image_links

    @original = @user.photos.find(params[:new_id]).image.url(:original)
    @cropped = @user.photos.find(params[:new_id]).image.url(:medium) 

    begin
      if @profile.save
        respond_to do |format|
          format.json  { render :json => [:original=>@original, :cropped=>@cropped], :status => :ok }
        end
    
      else
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => [:error_message => 'conversion failure'], :status => :ok }
        end
      end    
    
    rescue Paperclip::Errors::NotIdentifiedByImageMagickError
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with video upload. Please try again') }
          format.json  { render :json => [:error_message => 'cannot convert filetype'], :status => :ok }
        end    
    end
  
  end


  ########################################################
  # Custom crop a user photo
  ########################################################  
  def crop

    @user = current_user
    @profile = @user.profile
    @photo = @user.photos.find(params[:photo_to_crop_id])
    @photo.crop_x = params[:coordinates][:crop_x].to_i.to_s
    @photo.crop_y = params[:coordinates][:crop_y].to_i.to_s
    @photo.crop_w = params[:coordinates][:crop_w].to_i.to_s
    @photo.crop_h = params[:coordinates][:crop_h].to_i.to_s

    begin
      if @photo.image.reprocess!
        respond_to do |format|
          format.json  { render :json => [user_photo_id: @photo.id, refresh_photo_url: @photo.image(:medium) ], :status => :ok }
        end
    
      else
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with this photo upload. Please try again') }
          format.json  { render :json => [:error_message => 'conversion failure'], :status => :ok }
        end
      end    
    
    rescue Paperclip::Errors::NotIdentifiedByImageMagickError
        respond_to do |format|
          #format.html  { redirect_to(edit_profile_url(@profile), :notice => 'There was an issue with this photo upload. Please try again') }
          format.json  { render :json => [:error_message => 'cannot convert filetype'], :status => :ok }
        end    
    end
  
  end


  ########################################################
  # Delete a user photo
  ########################################################   
  def destroy
    @id = params[:id]
    @user = current_user
    @profile = @user.profile
    @user_photo = @user.photos.find(@id)

    if @profile.image_links['profile_image'] == @id
      @profile.image_links = @profile.image_links.delete(:profile_image)
      @profile.save
    end

    @user_photo.image.destroy


    if @user_photo.destroy
      respond_to do |format|
        format.json  { render :json => [:id=>@id], :status => :ok }
      end
    
    else 
      respond_to do |format|
        format.json  { render :json => @profile.errors, :status => :unprocessable_entity }
      end
    
    end  
    
  end


  def photos_reprocess

    UserPhoto.all.each {|s| s.image.reprocess! if s.image} if current_user.id = 127127
    UserVideo.all.each {|s| s.image.reprocess! if s.image} if current_user.id = 127127

    respond_to do |format|
      format.html { redirect_to(dashboard_url, :notice=>"All photo reprocessing was successful.") }
      format.json { render json: @profile.errors, status: :unprocessable_entity }
    end

  end


end