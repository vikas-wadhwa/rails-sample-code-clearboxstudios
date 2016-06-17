module ApplicationHelper

  PLACEHOLDER_IMAGES = [Profile::PLACEHOLDER_IMAGE_URL, Project::PLACEHOLDER_IMAGE_URL, Project::PLACEHOLDER_VIDEO_IMAGE_URL]

  def s_to_bool(str)
    str == 'true'
  end

  def convert_seconds_to_time(seconds)
    if seconds
      time_string = ''
      hours_string = seconds / 1.hours

      minutes = seconds / 1.minutes
      minute_string = minutes - (hours_string*60)

      seconds_string = seconds - (hours_string*3600) - (minute_string * 60)
      time_string = "%02d" % hours_string.to_s + ':' if hours_string > 0
      time_string += "%02d" % minute_string.to_s + ':' + "%02d" % seconds_string.to_s
    end
  end

  def link_if_exists(name, link, style, tooltip)
    if link.blank?
      return ""
    else
      link_to name, link, :class => style , :title => tooltip
    end
  end

  def mail_if_exists(name, email, style, tooltip)
    if email.blank?
      return ""
    else
      mail_to email, name, :class => style , :title => tooltip
    end
  end


  def radio_box(form, method, label, *options)

    if label == form.object.send(method)
      status_css = "disabled success"
    end

    output =  raw("#{form.radio_button method, label, class: 'hidden'}
                <span id='#{form.object_name.gsub(/\s+/, "_")}_#{method.gsub(/\s+/, "_")}_#{label.downcase.gsub(/\s+/, "_")}_radiobox'
                      class='radiobox button hollow small icon-check #{status_css}'>#{label}
                </span>")
    output.html_safe
  end



  def checkbox(method, html_options, checked_value, unchecked_value, label, form: {}, object: {} )

    if form.present?
      status_css = "success" if form.object.send(method).to_s == checked_value
      output = form.check_box method, html_options, checked_value, unchecked_value

    else
      status_css = "disabled"
      status_css += "success" if object.send(method).to_s == checked_value
      output = ""
    end

    output += raw("<span id='#{form.object_name.gsub(/\s+/, "_")}_#{method.gsub(/\s+/, "_")}_checkbox'
                     class='checkbox button hollow small icon-check #{status_css}'>#{label}</span>")
    output.html_safe

  end


  def usa_states
    Array[ ["AK", "Alaska"],
           ["AL", "Alabama"],
           ["AR", "Arkansas"],
           ["AS", "American Samoa"],
           ["AZ", "Arizona"],
           ["CA", "California"],
           ["CO", "Colorado"],
           ["CT", "Connecticut"],
           ["DC", "District of Columbia"],
           ["DE", "Delaware"],
           ["FL", "Florida"],
           ["GA", "Georgia"],
           ["GU", "Guam"],
           ["HI", "Hawaii"],
           ["IA", "Iowa"],
           ["ID", "Idaho"],
           ["IL", "Illinois"],
           ["IN", "Indiana"],
           ["KS", "Kansas"],
           ["KY", "Kentucky"],
           ["LA", "Louisiana"],
           ["MA", "Massachusetts"],
           ["MD", "Maryland"],
           ["ME", "Maine"],
           ["MI", "Michigan"],
           ["MN", "Minnesota"],
           ["MO", "Missouri"],
           ["MS", "Mississippi"],
           ["MT", "Montana"],
           ["NC", "North Carolina"],
           ["ND", "North Dakota"],
           ["NE", "Nebraska"],
           ["NH", "New Hampshire"],
           ["NJ", "New Jersey"],
           ["NM", "New Mexico"],
           ["NV", "Nevada"],
           ["NY", "New York"],
           ["OH", "Ohio"],
           ["OK", "Oklahoma"],
           ["OR", "Oregon"],
           ["PA", "Pennsylvania"],
           ["PR", "Puerto Rico"],
           ["RI", "Rhode Island"],
           ["SC", "South Carolina"],
           ["SD", "South Dakota"],
           ["TN", "Tennessee"],
           ["TX", "Texas"],
           ["UT", "Utah"],
           ["VA", "Virginia"],
           ["VI", "Virgin Islands"],
           ["VT", "Vermont"],
           ["WA", "Washington"],
           ["WI", "Wisconsin"],
           ["WV", "West Virginia"],
           ["WY", "Wyoming"]
    ]
  end

  def select_usa_states
    usa_states
  end


  def image_button(type, link_url, src_url, title, description, bottom_left, bottom_right)
    link_css_text = ""
    link_css_text = " hover" if PLACEHOLDER_IMAGES.include? src_url
    link_css_text += " hd-video" if type == "16x9"
    subheader_div =   "<div class='details-subheader'>" + description.limitation(50) +  "</div>"

    if type == "16x9"
      subheader_closed =   "</div>#{subheader_div}"

    elsif type == "1x1"
      subheader_closed =   "#{subheader_div}</div>"

    else
      subheader_closed = "</div>"
    end

    output = "<a class='liftable-container' href='#{link_url}'>
                <div class='image-button material-card liftable #{link_css_text}'>
                  <div id='icon_processing' class='icon-spin6 animate-spin processing''></div>
                  <div class='details-header'>
                    <h5 class='details-title'>#{title}</h5>
                    #{subheader_closed}
    #{image_tag(src_url)}
                    <div class='details-footer'>
                      <span class='details-bottom-left text-left'>#{bottom_left}</span>
                      <span class='show-for-medium-up details-bottom-right text-right'>#{bottom_right}</span>
                    </div>
                </div>
              </a>"
    output.html_safe

  end



  def image_checkbox(image_src_url, title, description, bottom_left, bottom_right, checked)

    css_text = " hover" if PLACEHOLDER_IMAGES.include? image_src_url

    css_checked = " on" if checked
    extra_description = "<span class='orange'>  ...see more</span>" if description.length > 100

    output = "<div class='image-button checkbox #{css_text}'>
                <div id='icon_processing' class='icon-spin6 animate-spin processing''></div>
                <span class='details-header'>#{title}
                  <span class='details-subheader'> #{description.first(100)}
    #{extra_description}
                  </span>
                </span>
                <span class='details-bottom-left'>#{bottom_left}</span>
                <span class='show-for-medium-up details-bottom-right'>#{bottom_right}</span>
                #{image_tag(image_src_url)}
                <span class='overlay icon-check white #{css_checked}'></span>
              </div>"
    output.html_safe

  end


  def icon_button(link_object, type, text)
    button =    "<div class='image-icon-button'>
                  <i class='icon-#{type}'></i>
                  <div class='details-bottom'>#{text}</div>
                </div>"
    output = link_to raw(button), link_object, class: ""
  end


  def contact_info_link(text, info)
    output = "<h5>#{text}</h5><span class='contact-info'>#{info}</span>"
    output.html_safe
  end


  def video_player(video)
    output =  "<video id='video_player_container' controls='controls' poster='#{video.image.url(:large)}' width='' height=''>
                <source src='#{video.url(:mp4)}' type='video/mp4'/>
                  <object type='application/x-shockwave-flash' data='http://releases.flowplayer.org/swf/flowplayer-5.5.2.swf' width='' height=''>
                    <param name='movie' value='http://releases.flowplayer.org/swf/flowplayer-5.5.2.swf' />
                    <param name='allowFullScreen' value='true' />
                    <param name='wmode' value='transparent' />
                    <param name='flashVars' value=\"config={'playlist':['#{video.image.url(:large)}',{'url':'#{video.url(:mp4)}','autoPlay':false}]} \"/>
                    <img alt='#{video.title}' src='#{video.image.url(:large)}' width='100%' title='Your current browser cannot play our videos.'>
                  </object>
                </video>"
    output.html_safe

  end




  def image_gallery_item(image, type)

    @profile_class =  image.try(:is_profile?) ? "class='photo-is-profile'" : ""
    @editable_node =  "<div id='icon_image_#{image.id.to_s}_processing' class='icon-spin6 animate-spin processing'></div>"  if type == "editable"

    output =  "<div class='column image-gallery-context-menu'>
              <a class='liftable-container popup-item'
                 src='#{image.download_url(:original)}'
                 data-download-src='#{image.download_url(:original)}'
                 title='#{image.caption}' data-mfp-src='#{image.download_url(:large)}'>

                <div  id='#{image.id.to_s}_image_container'
                      data-base-routing-path='#{image.class::BASE_ROUTING_PATH}'
                      data-update-routing-path='#{image.class::CRUD_ROUTING_PATHS[:update]}'
                      data-crop-routing-path='#{image.class::CRUD_ROUTING_PATHS[:crop]}'
                      data-destroy-routing-path='#{image.class::CRUD_ROUTING_PATHS[:destroy]}'>
                  #{@editable_node}
                  <div class='material-card liftable'>
                    <img #{@profile_class} id='image_menu_#{image.id.to_s}_toggle' src='#{asset_path(image.image.url(:medium))}' />
                  </div>
                  <span id='image_src_#{image.id.to_s}_large' class='thumbnail-src-large'>#{asset_path(image.image.url(:large))}</span>
                  <span id='image_src_#{image.id.to_s}_original' class='thumbnail-src-original'>#{asset_path(image.image.url(:fullsize))}</span>
                </div>
               </a>
             </div>"

    output.html_safe
  end



  def video_gallery_item(video, type)
    button = image_button( "16x9",
                           "#",
                           video.image.url(:medium),
                           video.title,
                           video.description,
                           convert_seconds_to_time(video.duration),
                           video.updated_at.strftime("%b %d, %Y"))

    output = "<div  id='#{video.id.to_s}_video_container' class='video-#{type}' 
                    data-base-routing-path='#{video.class::BASE_ROUTING_PATH}'
                    data-update-routing-path='#{video.class::CRUD_ROUTING_PATHS[:update]}'
                    data-crop-routing-path='#{video.class::CRUD_ROUTING_PATHS[:crop]}'
                    data-destroy-routing-path='#{video.class::CRUD_ROUTING_PATHS[:destroy]}'
                    data-edit-routing-path='#{video.edit_routing_path}'>

                <span id='video_data_#{video.id.to_s}'
                      data-thumbnail-src-original='#{asset_path(video.image.url(:fullsize))}'
                      data-url='#{video.video.url}'
                      data-fallback-image='#{asset_path(video.image.url(:large))}'
                      data-content-type='#{video.video.content_type}'
                      data-title='#{video.title}'
                      data-description='#{video.description}'
                      data-uploader='#{video.uploader.full_name}'>
                </span>
                #{button}
              </div>"

    output.html_safe
  end


end
