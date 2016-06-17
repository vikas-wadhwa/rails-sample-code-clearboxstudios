class UserDocumentsController < ApplicationController


  ########################################################
  # display documents and galleries for the User
  ########################################################
  def index

  end



  ########################################################
  # take incoming POST picture, save, and set as profile
  ########################################################
  def create

    #for plupload rename "file" to expected "document[data]"  
    if(params[:file])
      params[:user_document] = params[:file]
    end

    @user = current_user
    @profile = @user.profile
    @user_document = @user.documents.create(:document=>params[:user_document])

    begin

      if @user_document.save

        unless @profile.document_links.has_key?(:profile_document)
          @profile.document_links.merge!(:profile_document => @user_document.id)
          @profile.save
        end

        respond_to do |format|
          format.json  { render :json => [:document_gallery_item_id => @user_document.id, :created_document_url => @user_document.document.url(:large), :document_gallery_item => view_context.document_gallery_item_editable(@user_document)], :status => :ok }
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
    @document_links = {:profile_document => params[:new_id]}
    @profile.document_links = @document_links

    @original = @user.documents.find(params[:new_id]).document.url(:original)
    @cropped = @user.documents.find(params[:new_id]).document.url(:medium)

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
  # Custom crop a user document
  ########################################################  
  def crop

    @user_document_id = params[:document_to_crop_id]
    @user = current_user
    @profile = @user.profile
    @user_document = @user.documents.find(@user_document_id)
    @user_document.crop_x = params[:coordinates][:crop_x].to_i.to_s
    @user_document.crop_y = params[:coordinates][:crop_y].to_i.to_s
    @user_document.crop_w = params[:coordinates][:crop_w].to_i.to_s
    @user_document.crop_h = params[:coordinates][:crop_h].to_i.to_s

    begin
      if @user_document.document.reprocess!
        respond_to do |format|
          format.json  { render :json => [:user_document_id=>@user_document_id], :status => :ok }
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
  # Delete a user video
  ########################################################   
  def destroy
    @id = params[:id]
    @user = current_user
    @profile = @user.profile
    @user_document = @user.documents.find(@id)
    @user_document.document.destroy

    if @user_document.destroy
      respond_to do |format|
        format.json  { render :json => [:id=>@id], :status => :ok }
      end

    else
      respond_to do |format|
        format.json  { render :json => @profile.errors, :status => :unprocessable_entity }
      end

    end

  end


end