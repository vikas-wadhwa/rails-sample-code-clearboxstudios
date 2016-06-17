
//////////////////////////////////////////////////////////////////////////////////////
// Define video player modal constants, per convention
//////////////////////////////////////////////////////////////////////////////////////
var video_object = $('#video_player_container'),
    video_modal = $('#video_preview_modal');



//////////////////////////////////////////////////////////////////////////////////////
// These data are stored as separate <span> tags, rather than embedded within the main
//  video tag. This is slated for update.
//////////////////////////////////////////////////////////////////////////////////////
function update_video_player(video_id){

    data = $('#video_data_' + video_id);

    video_modal.find('#video_uploader').html(data.data('uploader'));
    video_modal.find('#video_description').html(data.data('description'));
    video_modal.find('#video_title').html(data.data('title'));
    video_modal.find('#video_controls').attr('poster', data.data('fallback-image'));
    video_modal.find('#video_preview_source').attr('src', data.data('url'));

    video_object.attr('poster', data.data('fallback-image'));
    video_object.find('source').attr('src', data.data('url'));
    video_object.find('img').attr('alt', data.data('title'));
    video_object.find('img').attr('src', data.data('fallback-image'));

    video_object.load();

    video_modal.foundation('open');

}


//////////////////////////////////////////////////////////////////////////////////////
// Global video clicker bind events
//////////////////////////////////////////////////////////////////////////////////////
$(document).ready(function () {

    $( ".video-playable" ).click(function() {
        var video_id = this.id.slice(0, this.id.length - '_video_container'.length);
        update_video_player(video_id);
    });

});