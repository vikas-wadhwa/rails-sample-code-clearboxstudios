module ProfilesHelper

  def input_with_privacy_checkbox(f, *category, field)

    if category.any?
      fields = f.fields_for *category do |item_field|
        item_field.text_field field, :value => @profile.contact_links[field]
      end
    else
      fields = f.text_field field
    end

    output = raw("<div class='columns small-10 medium-11'>#{fields}</div>
              <div class='columns small-2 medium-1'> #{privacy_checkbox(f, field.to_s)} </div>")

    output.html_safe

  end


  def privacy_checkbox(f, field)

    if @profile.privacy_settings[field]=="true"
      status_css = "icon-checkbox-checked"
    else
      status_css = "icon-checkbox"
    end

    output = f.fields_for :privacy_settings do |privacy_item_field|
      privacy_item_field.hidden_field field, :value => @profile.privacy_settings[field].nvl("false")
    end

    output +=  raw("<label id='profile_privacy_settings_#{field}_checkbox'
                       class='inline icon-search-right #{status_css} title='include in public searches?'>
                </label>")

    output.html_safe

  end


  def profile_social_links(profile)

    links = ""
    contacts_in_profile = []
    CONTACT_LINKS_LIST.each {|contact| contacts_in_profile.push(contact) unless profile.contact_links[contact].blank?}

    contacts_in_profile.each do |contact|

        #  add css class for foundation for sites to mark the last entry column as END
        #  using "end" if contact == profile_contacts_list.last
        if contact == "email"
          attributes = "href='mailto:#{profile.contact_links[contact]}' class='icon-post'"
        else
          attributes = "href='#{profile.contact_links[contact]}' class='icon-#{contact.downcase}'"
        end

        links = "#{links}
                <div class='column stat-icon #{'end' if contact == contacts_in_profile.last}'>
                   <a title='#{profile.name_first}&rsquo;s #{contact.capitalize} page' #{attributes}></a>
                </div>"
    end

    puts links

    links.html_safe

  end



end
