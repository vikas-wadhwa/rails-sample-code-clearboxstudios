///////////////////////////////////////////
// Global variables
///////////////////////////////////////////

$('#video_hours').val(secondsToTime($('#video_duration').val()).hours);
$('#video_minutes').val(secondsToTime($('#video_duration').val()).minutes);
$('#video_seconds').val(secondsToTime($('#video_duration').val()).seconds);


function upload_completion(item){
    
    if (Object.getOwnPropertyNames(plupload_forms).length === 0) {
        video_upload_progress_modal.foundation('close');
        photo_upload_progress_modal.foundation('close');
    }

}


function upload_failure(item){


}

function bind_tiny_photo_update(textinput){

    textinput.bind('railsAutocomplete.select', function(event, data){
        textinput.closest('.row.collapse').find('img').attr('src', data.item.image_url)
    });


}


function bind_credit_removal() {
    $('.screencredit-line-remove').click(function () {
        $(this).prev("input[type=hidden]").val("true");
        $(this).parents(".screencredit-line").hide();
    });
}


$(function () {

    bind_credit_removal()

    ///////////////////////////////////////////////////////////////////////
    //  When a single image is set for upload to be a thumbnail,
    //  we need a visual indicator. The element here will be updated
    //  with the new filename upon file add.
    ///////////////////////////////////////////////////////////////////////

    video_photo_uploader.bind('FilesAdded', function (up, files) {
        plupload.each(files, function (file) {
            $.each(files, function (i, file) {
                $('#video_photo_thumbnail_new_url i').html(file.name);
            });
        });
    });

    /********************************************************************************
      $('input[data-autocomplete]').bind('autocompletechange', function(event, ui) {
     // rails3-jquery-autocomplete fills in ui.item with selected
     // value, or sets it to null if no value selected.
     if(!ui.item) {            // if nothing selected
     $(this).val('');        // clear this field's value
     clearDataValues(this);  // clear values in "id" and "update_elements" fields
     }
     });
     *********************************************************************************/




    $('#screencredit-line-add').click(function () {
        var new_id = new Date().getTime();
        var regex = new RegExp("randomize", "g");
        $(".screencredits-box").append($("#screencredit-line-basis").html().replace(regex, new_id));
        newInput = $('#user_video_user_credits_attributes_' + new_id + '_user_full_name');
        newInput.bind('railsAutocomplete.select', function(event, data){
            bind_tiny_photo_update($(this));
        });
        bind_credit_removal()
    });


    $(".screencredits-box").find("input[id$='_user_full_name']").each(function() {
        bind_tiny_photo_update($(this));
    });


    $('#video_upload_clicker').click(function () {

        $('#video_processing').show();

        ///////////////////////////////////////////
        // Ajax call to create the video db entry
        ///////////////////////////////////////////
        $('#video_duration').val(
            parseInt($("#video_hours").val() * 60 * 60)
        + parseInt($("#video_minutes").val() * 60)
        + parseInt($("#video_seconds").val())
        );

        $.ajax({
            type: $('#video_form')[0].method,
            url: $('#video_form')[0].action,
            data: $("#video_form").serialize(),

            success: function (data) {

                ///////////////////////////////////////////
                // Set the directory path for the upload
                ///////////////////////////////////////////
                video_id = data.video_id;
                aws_videos_path = data.aws_videos_path;
                //video_gallery_item = data.video_gallery_item;

                ///////////////////////////////////////////
                // Start the video file upload
                ///////////////////////////////////////////
                $('#video_file_upload_starter').click();

                ///////////////////////////////////////////
                // Start the video thumbnail upload
                ///////////////////////////////////////////
                $('#video_photo_upload_starter').click();

                ///////////////////////////////////////////
                // Trigger whether to close or not
                ///////////////////////////////////////////
                //upload_completion();

            },

            error: function (request, status, error) {

                $('#error_explanation ul li').remove();
                errors = JSON.parse(request.responseText);

                $.each(errors, function (key, value) {
                    $.each(value, function (message) {

                        $('#error_explanation ul').append('<li>' + key + ' ' + value[message] + '</li>');

                    });
                });


                form_error_modal.foundation('open');
            }
        });

    });
});
