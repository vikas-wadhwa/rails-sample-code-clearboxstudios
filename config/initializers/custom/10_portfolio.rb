###################################################
##  Load the CDN location for photos
###################################################
PORTFOLIO_PATH =  "#{AWS_CDN_PUBLIC_URL}/portfolio/photos/"

image_names = %w[
    DSC_0004.jpg
    DSC_0022.jpg
    DSC_0056.jpg
    DSC_0062.jpg
    DSC_0070.jpg
    DSC_0082.jpg
    DSC_0100.jpg
    DSC_0107.jpg
    DSC_0116.jpg
    DSC_0137.jpg
    DSC_0153.jpg
    DSC_0184.jpg
    DSC_0197.jpg
    DSC_0260.jpg
    DSC_0284.jpg
    DSC_0285.jpg
    DSC_0286.jpg
    DSC_0317.jpg
    DSC_0318.jpg
]

###################################################
##  Load the CDN location for photos
###################################################
PORTFOLIO_PHOTOS = {


    #### Motion Graphics
    df_mobile_geotargeting: {src:  "#{PORTFOLIO_PATH}df_mobile_geotargeting.jpg",
             description: "Type: <b>Motion Graphics</b>"
    },


    #### Daisies
    daises: {src:  "#{PORTFOLIO_PATH}DSC_0286.jpg",
             description: "Type: <b>Actor Headshot</b>"
    },

    ### Mikel
    mikel: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 0267.jpg",
            description: "Type: <b>Corporate Headshot</b>"
    },

    ### Kory
    kory: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 0949.jpg",
           description: "Type: <b>Corporate Headshot</b>"
    },

    ### Meg Dysart
    meg: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 1760.jpg",
          description: "Type: <b>Corporate Headshot</b>"
    },

    ### Courtney Lyons
    courtney: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 2304.jpg",
               description: "Type: <b>Corporate Headshot</b>"
    },


    ### Justin Kim
    justin_kim: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 2457.jpg",
                 description: "Type: <b>Corporate Headshot</b>"
    },


    ### Melissa Gambino
    melissa: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 3123.jpg",
              description: "Type: <b>Corporate Headshot</b>"
    },


    ### Justin Bennett
    justin_bennett: {src:  "#{PORTFOLIO_PATH}2015.02.19 - SalesForce - 4510.jpg",
                     description: "Type: <b>Corporate Headshot</b>"
    },



    ### Choenig and Johnson
    couple: {src:  "#{PORTFOLIO_PATH}2015.02.24 - SalesForce - 0172.jpg",
             description: "Type: <b>Couples</b>"
    },


    ### Kristin Shumake
    kristin: {src:  "#{PORTFOLIO_PATH}2015.02.24 - SalesForce - 6732.jpg",
              description: "Type: <b>Corporate Headshot</b>"
    },


    ### Jason Michalak
    jason: {src:  "#{PORTFOLIO_PATH}2015.02.24 - SalesForce - 9949.jpg",
            description: "Type: <b>Corporate Headshot</b>"
    },


    ### Amy headshot
    amy_headshot: {src:  "#{PORTFOLIO_PATH}DSC_0137.jpg",
                   description: "Type: <b>Actor Headshot</b>"
    },

    ### Amy and Boomer sitting
    amy_boomer_sitting: {src:  "#{PORTFOLIO_PATH}DSC_0004.jpg",
                         description: "Type: <b>Families, Animals</b>"
    },

    ### Ogunquit
    ogunquit: {src:  "#{PORTFOLIO_PATH}DSC_0022.jpg",
               description: "Type: <b>Surreal, Travel, Landscape</b>"
    },

    ### Kay
    kay: {src:  "#{PORTFOLIO_PATH}DSC_0023.jpg",
          description: "Type: <b>Candid</b>"
    },

    ### Vertigo
    vertigo: {src:  "#{PORTFOLIO_PATH}DSC_0056.jpg",
              description: "Type: <b>Stock, Landscape, Architecture</b>"
    },

    ### Flamingo
    flamingo: {src:  "#{PORTFOLIO_PATH}DSC_0062.jpg",
               description: "Type: <b>Stock, Animals</b>"
    },

    ### Mahir
    mahir: {src:  "#{PORTFOLIO_PATH}DSC_0070.jpg",
            description: "Type: <b>Families, Children</b>"
    },

    ### lawrence
    lawrence: {src:  "#{PORTFOLIO_PATH}DSC_0076.jpg",
               description: "Type: <b>Corporate Headshot</b>"
    },

    ### italian road
    italian_road: {src:  "#{PORTFOLIO_PATH}DSC_0082.jpg",
                   description: "Type: <b>Surreal</b>"
    },

    ### Rhino
    rhino: {src:  "#{PORTFOLIO_PATH}DSC_0100.jpg",
            description: "Type: <b>Animals</b>"
    },

    ### Art Institute
    art_institute: {src:  "#{PORTFOLIO_PATH}DSC_0107.jpg",
                    description: "Type: <b>Architecture</b>"
    },


    ### Chicago River
    river_scrapers: {src:  "#{PORTFOLIO_PATH}DSC_0116.jpg",
                     description: "Type: <b>Architecture, Landscapes</b>"
    },

    ### Marble Statue
    greek_god: {src:  "#{PORTFOLIO_PATH}DSC_0130.jpg",
                description: "Type: <b>Art, Architecture</b>"
    },

    ### Railroad
    railroad: {src:  "#{PORTFOLIO_PATH}DSC_0153.jpg",
               description: "Type: <b>Surreal, Landscape</b>"
    },


    ### Boomer
    boomer: {src:  "#{PORTFOLIO_PATH}DSC_0154.jpg",
             description: "Type: <b>Animals</b>"
    },

    ### Amy_Beach
    amy_beach: {src:  "#{PORTFOLIO_PATH}DSC_0184.jpg",
                description: "Type: <b>Candid</b>"
    },

    ### Amy Michigan Bridge
    amy_bridge: {src:  "#{PORTFOLIO_PATH}DSC_0197.jpg",
                 description: "Type: <b>Surreal, Landscape</b>"
    },

    ### Hawaii Beach
    beach_shadow: {src:  "#{PORTFOLIO_PATH}DSC_0237.jpg",
                   description: "Type: <b>Candid</b>"
    },

    ### Amy Michigan Forest
    amy_forest: {src:  "#{PORTFOLIO_PATH}DSC_0249.jpg",
                 description: "Type: <b>Surreal, Landscape</b>"
    },

    ### Michigan Forest
    michigan_forest: {src:  "#{PORTFOLIO_PATH}DSC_0260.jpg",
                      description: "Type: <b>Surreal, Landscape</b>"
    },

    ### Bird on Beach
    bird: {src:  "#{PORTFOLIO_PATH}DSC_0284.jpg",
           description: "Type: <b>Animals</b>"
    },

    ### Mountains
    mountains: {src:  "#{PORTFOLIO_PATH}DSC_0285.jpg",
                description: "Type: <b>Surreal, Landscape</b>"
    },
    ### Ninth Floor Stairwell
    stairwell: {src:  "#{PORTFOLIO_PATH}DSC_0317.jpg",
                description: "Type: <b>Light and Shadow</b>"
    },
    ### Fortune
    fortune: {src:  "#{PORTFOLIO_PATH}DSC_0318.jpg",
              description: "Type: <b>Light and Shadow</b>"
    },

    ### Amy and Boomer
    amy_boomer_walking: {src:  "#{PORTFOLIO_PATH}DSC_0462.jpg",
                         description: "Type: <b>Candid, Animals, Families</b>"
    },

    ## Ellie"s head
    eh_01: {src:  "#{PORTFOLIO_PATH}eh_01_small.jpg",
            description: "Type: <b>Light and Shadow</b>"

    },

    ## Ellie"s head
    ninth_floor: {src:  "#{PORTFOLIO_PATH}ninth_floor_02_small.jpg",
            description: "Type: <b>Light and Shadow</b>"

    },

    ## Ellie"s head
    panasonic: {src:  "#{PORTFOLIO_PATH}panasonic_01_small.jpg",
            description: "Type: <b>Light and Shadow</b>"

    }
}


###################################################
##  Create a list of URLs for cache download
###################################################
PORTFOLIO_PHOTOS_ARRAY = []
PORTFOLIO_PHOTOS.each do |photo|
  PORTFOLIO_PHOTOS_ARRAY.push(photo[1][:src])
end



###################################################
##  Wistia IDs
###################################################
WISTIA_THUMBNAILS_ARRAY = [
    "http://embed.wistia.com/deliveries/7fb5345af3e036cd5a9c7b4db0a435b3647297c6.jpg?image_crop_resized=640x360",
    "http://embed.wistia.com/deliveries/72d045986a36cef87d5edd0edfd8ec02688a41f9.jpg?image_crop_resized=960x540",
    "http://embed.wistia.com/deliveries/6e3a29d4347c5fa095d574cdb81398ef9b613b8d.jpg?image_crop_resized=640x360",
    "http://embed.wistia.com/deliveries/519984c5829a039b0eda9f30fba600000dd6962a.jpg?image_crop_resized=640x360",
    "http://embed.wistia.com/deliveries/97350186e244c854c7b0ec4568ef35eeb643a336.jpg?image_crop_resized=640x360",
    "http://embed.wistia.com/deliveries/39ccc9f1d7db685541a803894fe010835418aa78.jpg?image_crop_resized=640x360",
    "http://embed.wistia.com/deliveries/0fe9cc28ea2e9a1d1c02dbf0b9537b5ee175dafa.jpg?image_crop_resized=640x360"
]

WISTIA_PORTFOLIO_VIDEOS = {

    grinning_demons: {id: "ztvprp4drp",
                      description:
                          "Client: <b>Amazon Studios</b><br>
        <span class='show-for-medium-up'>Type: <b>Narrative</b></span>
        <br><br>
        The winning submission for Amazon Studios first book trailer contest.
        <br><br><span class='show-for-medium-up'>This trailer is based on the novel 'Seed' by Ania Ahlborn.</span>"
    },

    digital_factory: {id: "alm41dck3c",
                      description:
                          "Client: <b>Digital Factory</b><br>
        <span class='show-for-medium-up'>Type: <b>Motion Graphics</b></span>
        <br><br>
        This information sales video helps viewers digest what tech company Digital Factory offers for mobile geo-fencing.
        <br><br><span class='show-for-medium-up'>This video uses custom and third-party motion graphics.</span>"
    },

    great_gig: {id: "j6iimrf97f",
                description:
                    "Client: <b>Private</b>
        <span class='show-for-medium-up'><br>Type: <b>Special Effects</b></span>
        <br><br>
        Pink Floyd's 'Great Gig In The Sky' is interpreted in this abstract piece.
        <br><br><span class='show-for-medium-up'>This video uses green-screen composition and motion graphics.</span>"
    },

    garcc: {id: "pyka3b0zk2",
            description:
                "Client: <b>Greek American Rehabilitation & Care Centre</b>
        <span class='show-for-medium-up'><br>Type: <b>Interview/Documentary</b></span>
        <br><br>
        GARCC is a non-profit facility offering short term rehab & long term care with love, respect, honor & dignity.
        <br><br><span class='show-for-medium-up'>This video documents the GARCC facility and interviews doctors and patients.</span>"
    },

    trip: {id: "qauz7xkkyk",
           description:
               "Client: <b>Slalom Consulting</b>
        <span class='show-for-medium-up'><br>Type: <b>Amateur Bootcamp</b></span>
        <br><br>
        Slalom Consulting offers their corporate employees a chance to direct personal short films for special company film festivals.
        <br><br><span class='show-for-medium-up'>This video was envisioned, written, and directed by amateur IT consultants, produced by Clearbox Studios.</span>"
    },

    analytics: {id: "cawdky9jfa",
                description:
                    "Client: <b>Slalom Consulting</b>
        <span class='show-for-medium-up'><br>Type: <b>Interview</b></span>
        <br><br>
        Slalom Consulting highlights their Analytics department to help clients become people-driven organizations that are smart with data.
        <br><br><span class='show-for-medium-up'>This video is a panel discussion with 3 interviewees.</span>"
    },

    rooted: {id: "7ba8qaoe6z",
             description:
                 "Client: <b>Rooted Self-Expression Center</b>
        <span class='show-for-medium-up'><br>Type: <b>Fundraising</b></span>
        <br><br>
        Rooted gives you tools to experience & create many types art without worrying about the outcome.
        <br><br><span class='show-for-medium-up'>This fundraising video interviews Rooted's founder.</span>"
    },

    responsibility: {id: "g88pnt4r18",
                     description:
                         "Client: <b>Team Coalition</b>
        <span class='show-for-medium-up'><br>Type: <b>Public Service Announcement</b></span>
        <br><br>
        'Responsibility Has It's Rewards' promotes responsible drinking & positive fan behavior at
        sporting events & entertainment venues.
        <br><br><span class='show-for-medium-up'>This Public Service Announcement was written, directed, and produced by Clearbox Studios..</span>"
    }
}
