//////////////////////////////////////////////////////////////////////////////////////
// Global variables for a Jcrop object
//////////////////////////////////////////////////////////////////////////////////////
var jcrop_api,
    bounds,
    boundx,
    boundy,
    jcrop_source,
    jcrop_modal = $('#jcrop_modal'),
    jcrop_post_url = '',
    preview_container = $('#jcrop_preview_container');


//////////////////////////////////////////////////////////////////////////////////////
// Initiates/updates a Jcrop modal to a given photo URL and aspect ratio
//////////////////////////////////////////////////////////////////////////////////////
function update_jcrop_modal(id, photo_url, aspect) {

    $('#photo_to_crop_id').val(id);
    jcrop_modal.find('#jcrop_preview').attr('src', photo_url);

    jcrop_api.setImage(photo_url);
    jcrop_api.setOptions({ aspectRatio: eval(aspect) });

    $('#jcrop_preview_container').removeClass('aspect-1 aspect-16-9').addClass('aspect-' + aspect.replace(' / ', '-'));

    jcrop_modal.find('img').imagesLoaded(function () {
        setJcropSelection();
        jcrop_modal.foundation('open');
        return false;
    });

}



//////////////////////////////////////////////////////////////////////////////////////
// Initiates a cropping modal dialog and binds the do_crop action.
//   - This allows for definitions in #photo_to_crop_id and #jcrop_processing
//     on a per-page basis
//////////////////////////////////////////////////////////////////////////////////////
$(function() {

    box_dimension = 400;
    jcrop_source = $('#jcrop_source');

    ///////////////////////////////////////////
    // Jcrop configuration
    ///////////////////////////////////////////
    $('#jcrop_image_source').Jcrop({
        onRelease: clearCoords,
        onChange: showPreview,
        onSelect: showPreview,
        boxWidth: box_dimension,
        boxHeight: box_dimension,
        aspectRatio: 1

    },function(){
        jcrop_api = this;
        setJcropSelection();
    });


    $('#do_crop').click(function(){

        ///////////////////////////////////////////
        // Ajax call to crop pictures
        ///////////////////////////////////////////
        $('#jcrop_processing').show();

        datalist = JSON.stringify({
            coordinates: {
                crop_x: $("#x1").val(),
                crop_y: $("#y1").val(),
                crop_w: $("#w").val(),
                crop_h: $("#h").val()
            },
            photo_to_crop_id: $("#photo_to_crop_id").val()
        });

        $.ajax({
            type: "POST",
            dataType: "script",
            url: jcrop_post_url,
            contentType: 'application/json',
            data: datalist,
            success: function(response){

                data = jQuery.parseJSON(response);


                $.each(photos_to_refresh, function( i, obj ){
                   obj.src = data[0].refresh_photo_url
                });

                $('#jcrop_processing').hide();
                jcrop_modal.foundation('close');

                //window.location.reload(true);
            }
        });

    });


});



//////////////////////////////////////////////////////////////////////////////////////
// Set default cropping selection area.
//////////////////////////////////////////////////////////////////////////////////////
function setJcropSelection() {

    bounds = jcrop_api.getBounds();
    boundx = bounds[0];
    boundy = bounds[1];

    length = Math.min(boundx, boundy);

    jcrop_api.setSelect([
        (boundx - length)/2,
        (boundy - length)/2,
        (boundx - length)/2 + length,
        (boundy - length)/2 + length
    ]);
}


//////////////////////////////////////////////////////////////////////////////////////
// Customizes the Preview section of Jcrop dialog
//////////////////////////////////////////////////////////////////////////////////////
function showPreview(coords)
{

    $('#x1').val(coords.x);
    $('#y1').val(coords.y);
    $('#x2').val(coords.x2);
    $('#y2').val(coords.y2);
    $('#w').val(coords.w);
    $('#h').val(coords.h);
    
    if(typeof jcrop_api != 'undefined') {
        var rx = preview_container.width() / coords.w,
            ry = preview_container.height() / coords.h;

        bounds = jcrop_api.getBounds();
        boundx = bounds[0];
        boundy = bounds[1];

        $('#jcrop_preview').css({
            width: Math.round(rx * boundx) + 'px',
            height: Math.round(ry * boundy) + 'px',
            marginLeft: '-' + Math.round(rx * coords.x) + 'px',
            marginTop: '-' + Math.round(ry * coords.y) + 'px'
        });
    }

}



//////////////////////////////////////////////////////////////////////////////////////
// Clears coordinates if cancelled
//////////////////////////////////////////////////////////////////////////////////////
function clearCoords(){
    $('#coords input').val('');
    $('#h').css({color:'red'});
    window.setTimeout(function(){
        $('#h').css({color:'inherit'});
    },500);
};
