////////////////////////////////////////////////////////////
// Use Waypoints to have imagery slide in when in viewport
////////////////////////////////////////////////////////////

$(document).ready(function(){
  var waypoints = $('.background-image').waypoint({
    offset: '75%',
    handler: function(direction) {
      if (direction=='down') {
        $(this.element).addClass('in-view').addClass('in-view')
      }
    }

  })

});



