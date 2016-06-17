////////////////////////////////////////////////////////////
// Deprecated; we used this to rotate imagery in version 1.0
// keeping the library for possible reuse.
////////////////////////////////////////////////////////////

$(window).load(function() {

    var RotateImages =
    {
        init: function()
        {
            //initial fade-in time (in milliseconds)
            var initialFadeIn = 1000;

            //interval between items (in milliseconds)
            var itemInterval = 6000;

            //cross-fade time (in milliseconds)
            var fadeTime = 2500;

            //count number of items
            var numberOfItems = $('.background-image').length;

            //set current item
            var currentItem = 0;

            //show first item
            $('.background-image').eq(currentItem).fadeIn(initialFadeIn);

            if(numberOfItems > 1){

                //loop through the items
                var infiniteLoop = setInterval(function(){

                    $('.background-image').eq(currentItem).fadeOut(fadeTime);

                        if(currentItem == numberOfItems -1){
                            currentItem = 0;
                        }

                        else{
                            currentItem++;
                        }

                    $('.background-image').eq(currentItem).fadeIn(fadeTime);


                }, itemInterval);
            }
        }
    };

    RotateImages.init();

});