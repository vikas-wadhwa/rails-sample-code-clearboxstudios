///////////////////////////////////////////
// Bind context-menu classes
///////////////////////////////////////////

$(function () {

    //////////////////////////////////////////////////////////////////////////////////////
    // Define CSS selector values
    //////////////////////////////////////////////////////////////////////////////////////
    var context_menu_selector = '.video-gallery-context-menu',
        video_container_id_suffix = '_video_container',
        video_data_selector = '#video_data_',
        video_aspect_ratio = '16 / 9',
        thumbnail_source_selector = 'thumbnail-src-original';


    function find_video_data(video_object) {

        var video = video_object[0];
            video_id = video.id.slice(0, video.id.length - video_container_id_suffix.length);
            base_routing_path = video_object.data('base-routing-path'),
            update_routing_path = video_object.data('update-routing-path'),
            crop_routing_path = video_object.data('crop-routing-path'),
            destroy_routing_path = video_object.data('destroy-routing-path'),
            edit_routing_path = video_object.data('edit-routing-path'),
            thumbnail_src_original = $(video_data_selector + video_id).data(thumbnail_source_selector);


        result = {
            'video': video,
            'video_id': video_id,
            'base_routing_path': base_routing_path,
            'update_routing_path': update_routing_path,
            'crop_routing_path': crop_routing_path,
            'destroy_routing_path': destroy_routing_path,
            'edit_routing_path': edit_routing_path,
            'thumbnail_src_original': thumbnail_src_original
        };

        return result;
    }

    
    $.contextMenu({

        // define which elements trigger this menu
        selector: '.video-editable',
        trigger: 'left',
        zIndex: 99,

        // define the elements of the menu
        items: {

            "view": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-video"></i> <span>Open in player</span>' + opt.selector);
                },
                callback: function (key, options) {

                    var video_container = find_video_data(this);
                    update_video_player(video_container.video_id);
                }
            },


            "update": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-edit"></i> <span>Edit</span>' + opt.selector);
                },
                callback: function (key, options) {

                    var video_container = find_video_data(this);
                    document.location.href = video_container.edit_routing_path;
                }
            },


            "crop": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-scissors"></i> <span>Re-crop thumbnail</span>' + opt.selector);
                },
                callback: function (key, options) {

                    var video_container = find_video_data(this);

                    // photos_to_refresh is used by the Jcrop dialog upon crop ajax completion.
                    photos_to_refresh = this.find('img');

                    // jcrop_post_url is used by the Jcrop dialog to send the AJAX request.
                    jcrop_post_url = video_container.crop_routing_path;

                    update_jcrop_modal(video_container.video_id, video_container.thumbnail_src_original, video_aspect_ratio);
                }
            },


            "delete": {
                icon: function(opt, $itemElement, itemKey, item){
                    $itemElement.html('<i class="icon-cancel" style="color: white;"></i> <span>Delete</span>' + opt.selector);
                },
                callback: function (key, options) {

                    // Visual effects start when processing
                    this.find('img').fadeTo(0, 0.25);
                    this.find('.processing').show();

                    var video_container = find_video_data(this);

                    $.ajax({
                        type: "POST",
                        dataType: "script",
                        url: video_container.destroy_routing_path,
                        contentType: 'application/json',
                        data: JSON.stringify({id: video_container.video_id, _method: 'delete'}),

                        success: function (data) {
                            var ids = jQuery.parseJSON(data);
                            $('#' + ids[0].id + video_container_id_suffix).remove();
                        }

                    });
                }
            }


        }
    });

});
