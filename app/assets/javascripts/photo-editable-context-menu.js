//////////////////////////////////////////////////////////////////////////////////////
// Bind context-menu classes Photo objects, assuming normal aspect ratio of 1
//////////////////////////////////////////////////////////////////////////////////////

$(function () {


    // whenever this context-menu is called, you need to prevent normal gallery opening on click.
    popup_selector = '.popup-item';
    $(popup_selector).unbind('click');


    //////////////////////////////////////////////////////////////////////////////////////
    // Define CSS selector values
    //////////////////////////////////////////////////////////////////////////////////////
    var context_menu_selector = '.image-gallery-context-menu',
        image_container_id_suffix = '_image_container',
        image_container_selector = '[id*="_image_container"]',
        thumbnail_source_selector = '.thumbnail-src-original';


    function find_image_data(image_object) {
        var image = image_object.find(image_container_selector),
            picture_id = image.attr('id').slice(0, image.attr('id').length - image_container_id_suffix.length),
            image_url = image.find(thumbnail_source_selector).html(),
            base_routing_path = image.data('base-routing-path'),
            update_routing_path = image.data('update-routing-path'),
            crop_routing_path = image.data('crop-routing-path'),
            destroy_routing_path = image.data('destroy-routing-path');

        result = {
                    'image': image,
                    'picture_id': picture_id,
                    'image_url': image_url,
                    'base_routing_path': base_routing_path,
                    'update_routing_path': update_routing_path,
                    'crop_routing_path': crop_routing_path,
                    'destroy_routing_path': destroy_routing_path
        };

        return result;
    }



    $.contextMenu({

        // define which elements trigger this menu
        selector: context_menu_selector,
        trigger: 'left',
        zIndex: 99,


        // define the elements of the menu
        items: {

            "view": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-picture"></i> <span>View Larger</span>' + opt.selector);
                },

                callback: function (key, options) {

                    popupIndex = $(popup_selector).index(  $(this).children(popup_selector) );
                    $(this).children(popup_selector).magnificPopup('open', popupIndex);
                }

            },

            "set": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-user"></i> <span>Set as profile picture</span>' + opt.selector);
                },
                callback: function (key, options) {

                    var image_container = find_image_data($(this));

                    $.ajax({
                        type: "POST",
                        dataType: "script",
                        url: image_container.update_routing_path,
                        contentType: 'application/json',
                        data: JSON.stringify({new_id: image_container.picture_id, _method: 'put'}),

                        success: function (data) {
                            var urls = jQuery.parseJSON(data);
                            $("#profile_picture").attr("src", urls[0].cropped);
                            jcrop_api.setImage(urls[0].original);
                            $('#image_to_crop_id').val(image_container.picture_id);
                            $('.photo-is-profile').removeClass('photo-is-profile')
                            $('#image_menu_' + image_container.picture_id + '_toggle').addClass('photo-is-profile' )
                        }

                    });

                }
            },

            "crop": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-scissors"></i> <span>Re-crop</span>' + opt.selector);
                },
                callback: function (key, options) {

                    var image_container = find_image_data($(this));
                    jcrop_post_url = image_container.crop_routing_path;
                    photos_to_refresh =  image_container.image.find('img');

                    if (this.find('img').hasClass('photo-is-profile')) {
                        photos_to_refresh = photos_to_refresh.add("#profile_picture");
                    }

                    update_jcrop_modal(image_container.picture_id, image_container.image_url, '1');
                }
            },


            "delete": {

                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-cancel" style="color: rgb(255, 0, 0);"></i> <span>Delete</span>' + opt.selector);
                },


                callback: function (key, options) {

                    var image_container = find_image_data($(this));
                    image_container.image.find('img').fadeTo(0, 0.25);
                    image_container.image.find('.processing').show();

                    $.ajax({
                        type: "POST",
                        dataType: "script",
                        url: image_container.destroy_routing_path,
                        contentType: 'application/json',
                        data: JSON.stringify({id: image_container.picture_id, _method: 'delete'}),

                        success: function (data) {
                            var ids = jQuery.parseJSON(data);
                            $('#' + ids[0].id + '_image_container').parents(context_menu_selector).remove();
                        }

                    });
                }
            }


        }
    });

});