///////////////////////////////////////////
// Initialize an image gallery
///////////////////////////////////////////
$(document).ready(function() {

    $('.popup-item').magnificPopup({

        //delegate: 'a', // child items selector, by clicking on it popup will open
        type: 'image',
        // other options

        disableOn: 400,
        navigateByImgClick: true,

        mainClass: 'mfp-with-zoom', // this class is for CSS animation below

        zoom: {
            enabled: true, // By default it's false, so don't forget to enable it

            duration: 300, // duration of the effect, in milliseconds
            easing: 'ease-in-out', // CSS transition easing function

            // The "opener" function should return the element from which popup will be zoomed in
            // and to which popup will be scaled down
            // By defailt it looks for an image tag:
            opener: function(openerElement) {
                // openerElement is the element on which popup was initialized, in this case its <a> tag
                // you don't need to add "opener" option if this code matches your needs, it's defailt one.
                return openerElement.is('img') ? openerElement : openerElement.find('img');
            }
        },

        gallery: {
            // options for gallery
            enabled: true,
            navigateByImgClick: true
        },

        image: {
            verticalFit: true,
            titleSrc: function(item) {
                if (magnific_downloadable==true){
                    return '<a class="icon-download-cloud download" href="' + $(item.el.context).data('download-src') + '"></a>';
                }
            }
        }


    });

});

//////////////////////////////////////////////////////////////////////////////////////
// Bind a DOWNLOAD ALL button to the items in the defined gallery
//////////////////////////////////////////////////////////////////////////////////////
$('#download_all').click(function (event) {
    event.preventDefault();
    $('.popup-item').multiDownload();
});
