module PortfolioHelper

  def portfolio_image_gallery_item (item)
    
    output  = '<div class="no-overflow liftable-container"><a class="popup-item material-card liftable" src="' + asset_url(item[:src]) + '"'
    output += ' data-mfp-src="'  + asset_url(item[:src]) + '"'
    output += ' title="'  + item[:description] + '">'
    output += ' <img class="" src="' + asset_url(item[:src]) +'"></img></a></div>'
    output.html_safe

  end

  def div_gallery_item (item, style)

    output  = ' <a class="popup-item ' + style + ' portfolio-image" src="' + asset_url(item[:src]) + '"'
    output += ' style="background: url(' + "'" + asset_url(item[:src]) + "'" + ') no-repeat 50% 50%;" '
    output += ' data-mfp-src="'  + asset_url(item[:src]) + '"'
    output += ' title="'  + item[:description] + '"><img></a>'
    output.html_safe

  end


  def wistia_helper (item)

    output  = ' <div class="media-description-container"><a class="icon-button">i</a> '
    output += ' <p class="media-description animated fadeOut">' + item[:description] + '</p>'
    output += ' <div id="wistia_'  + item[:id] + '" class="wistia_embed"></div></div>'
    output.html_safe

  end



end
