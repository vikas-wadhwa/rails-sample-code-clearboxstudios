///////////////////////////////////////////
// Global variable for flowplayer objects
///////////////////////////////////////////
flowplayer.conf = {
    ratio: 9/16,
    analytics: "UA-27182341-1"
};



///////////////////////////////////////////
// define reload functions
///////////////////////////////////////////
function reload_flowplayer(video_url) {
    video_player.load(video_url)
}


///////////////////////////////////////////
// instantiate the flowplayer
///////////////////////////////////////////
flowplayer(function (api) {
    api.bind("load", function (e, api, video) {
    });
});


///////////////////////////////////////////
// assign flowplayer to object
///////////////////////////////////////////
$(document).ready(function () {
    video_player = flowplayer();


    if (typeof(video_player_empty) != "undefined") {
        video_player.unbind();
    }

});