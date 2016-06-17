
$(function() {
    
    /*-----------------------------------------------------------
    --  our 3 items 
    -----------------------------------------------------------*/
    var $listItems    = $('#rm_container > ul > li'),
        totalItems    = $listItems.length,

        /*-----------------------------------------------------------
        -- the controls
        -----------------------------------------------------------*/
        $rm_next    = $('#rm_next'),
        $rm_prev    = $('#rm_prev'),

        /*-----------------------------------------------------------
        -- check if the browser is <= IE8
        -----------------------------------------------------------*/
        ieLte8      = ($.browser.msie && parseInt($.browser.version) <= 8),
    


    RotateImageMenu = (function() {
    
        /*-----------------------------------------------------------
        -- difference of animation time between the items
        -----------------------------------------------------------*/
        var timeDiff      = 200,
        
        /*-----------------------------------------------------------
        -- checks if the images are rotating
        -----------------------------------------------------------*/
        isRotating      = false,
        
        /*-----------------------------------------------------------
        -- how many images completed each slideshow iteration
        -----------------------------------------------------------*/
        completed     = 0,
        
        /*-----------------------------------------------------------
        -- all our images have 310 of width and 465 of height.
        -- this could / should be dynamically calculated 
        -- if we would have different image sizes.
        -- 
        -- we will set the rotation origin at 
        -- x = width/2 and y = height*2
        -----------------------------------------------------------*/
        
        origin = ['320px', '960px'],
        init = function() {
                  rotationConfigure();
                  initEventsHandler();
               },
        
        
        /*-----------------------------------------------------------
        -- initialize some events
        -----------------------------------------------------------*/
        initEventsHandler = function() {
          

          /*-----------------------------------------------------------
          -- next and previous links:
          -- we will stop the slideshow if active and rotate each item
          -----------------------------------------------------------*/
          
          $rm_next.bind('click', function(e) {
            rotateImages(1);
            return false;
          });
          
          
          $rm_prev.bind('click', function(e) {
            rotateImages(-1);
            return false;
          });
          
        },
        
        
       /*-----------------------------------------------------------------------------
       -- rotates each items images. we set a delay between each item animation
       -----------------------------------------------------------------------------*/
        rotateImages = function(direction) {
          
          /*-----------------------------------------------------------
          -- if the animation is in progress return
          -----------------------------------------------------------*/
          if(isRotating) return false;
          
          isRotating = true;
          
          $listItems.each(function(i) {

            var $item         = $(this),

            /*-----------------------------------------------------------
            -- the delay calculation.
            -- if rotation is to the right, 
            -- then the first item to rotate is the first one, otherwise the last one
            -----------------------------------------------------------*/
            interval = (direction === 1) ? i * timeDiff : (totalItems - 1 - i) * timeDiff;
            
            setTimeout(function() {
            
                /*-----------------------------------------------------------
                -- the images associated to this item
                -----------------------------------------------------------*/
                var $otherImages = $('#' + $item.data('images')).children('a'),
                    totalOtherImages  = $otherImages.length;
                
                    // the current one
                    $img = $item.children('a:last').children('img:last'),

                    // keep track of each items current image
                    current = $item.data('current');
                
                /*-----------------------------------------------------------
                -- out of bounds 
                -----------------------------------------------------------*/
                
                if(current > totalOtherImages - 1)
                  current = 0;
                else if(current < 0)
                  current = totalOtherImages - 1;
                
                /*-----------------------------------------------------------
                ** the next image to show and its initial rotation (depends on direction)
                -----------------------------------------------------------*/
                var otherRotation = (direction === 1) ? '-30deg' : '30deg',
                    $other = $otherImages.eq(current).clone();
                
                /*-----------------------------------------------------------
                -- for IE <= 8 we will not rotate, but fade out / fade in ... 
                -- better than nothing :)  
                -----------------------------------------------------------*/
                if(!ieLte8)
                  $other.children('img').css({
                    rotate  : otherRotation,
                    origin  : origin
                  });
                
                
                
                (direction === 1) ? ++current : --current;
                
                /*-----------------------------------------------------------
                -- prepend the next image to the <li>
                -----------------------------------------------------------*/
                $item.data('current', current).prepend($other);

                
                /*-----------------------------------------------------------
                -- the final rotation for the current image 
                -----------------------------------------------------------*/
                var rotateTo    = (direction === 1) ? '80deg' : '-80deg';
                
                if(!ieLte8) {
                  
                  $('#playlist-title').html($('#rm_playlists li:eq('+ (current - 1) + ') span:eq(0)').html());
                  $('#playlist-description').html($('#rm_playlists li:eq('+ (current - 1) + ') span:eq(1)').html());
                  
                  $img.transform({origin: origin}).animate(
                    
                    {rotate  : rotateTo}, 
                    
                    {
                      duration: 1200, 

                      complete: function(){
                                  $(this).parent().remove();
                                  ++completed;

                                  if(completed === totalItems) {
                                    completed = 0;
                                    isRotating = false;
                                  }
                                }
                    }
                 
                  );
                  
                  $other.children('img').animate(
                    
                    {rotate  : '0deg'},
                    
                    {
                      duration: 600
                    }
                  
                  );
                }

                else {
                  $('#playlist-title').html($('#rm_playlists li:eq('+ (current - 1) + ') span:eq(0)').html());
                  $('#playlist-description').html($('#rm_playlists li:eq('+ (current - 1) + ') span:eq(1)').html());
                  
                  $img.fadeOut(1200, function(){
                    $(this).parent().remove();
                    ++completed;
                    
                    if(completed === totalItems) {
                      completed = 0;
                      isRotating = false;
                      
                    }
                  });
                }
                
            }, interval );  
          });
          
        },
        
        /*-----------------------------------------------------------
        -- set initial rotations
        -----------------------------------------------------------*/
        rotationConfigure = function() {

          $listItems.each(function(i) {
            
            /*-----------------------------------------------------------
            -- the initial current is 1 
            -- since we already showing the first image
            -----------------------------------------------------------*/
            var $item = $(this).data('current', 1);
            
            //if(!ieLte8)
            //$item.transform({rotate: $item.data('rotation') + 'deg'})
            //   .find('img')
            //   .transform({origin: origin});
          });
        };
      
      return {init : init};
      
      
    })();
    
    
    
  RotateImageMenu.init();


});



