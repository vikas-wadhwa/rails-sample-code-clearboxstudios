///////////////////////////////////////////
// Define a completed upload
///////////////////////////////////////////

function upload_completion(item){

    if (Object.getOwnPropertyNames(plupload_forms).length === 0) {
        video_upload_progress_modal.foundation('close');
        photo_upload_progress_modal.foundation('close');
    }

}

///////////////////////////////////////////
// Bind privacy setting checkboxes
///////////////////////////////////////////


$(function () {
    $('[id^=profile_privacy_settings_]').click(function () {

        field_id = this.id.substring(0, this.id.length - '_checkbox'.length);
        field_value = $('#' + field_id).val();

        field_value == "true" ? $('#' + field_id).val("false") : $('#' + field_id).val("true");

        $(this).toggleClass('icon-checkbox icon-checkbox-checked');
    });
});
