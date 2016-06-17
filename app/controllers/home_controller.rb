class HomeController < ApplicationController

  ###################################################
  ##  Load the CDN location for photos
  ###################################################
  BACKGROUND_IMAGES_ARRAY = image_names.map { |filename| "#{PORTFOLIO_PATH}#{filename}" }
  
  BACKGROUND_PHRASES = %w[
      home-white-01.svg
      home-white-02.svg
      home-white-03.svg
      home-black-04.svg
  ]

  CDN_CASE_STUDIES_PATH = "#{AWS_CDN_PUBLIC_URL}/case_studies/photos/"

  CASE_STUDIES = {

      'salesforce' => {
          id: 'salesforce',
          title: 'Salesforce.com',
          description: 'Salesforce.com is a global leader in CRM and Cloud computing solutions.
                          When a Chicago team member wanted an updated set of professional  photos,
                          he reached out to Clearbox Studios for options to shoot
                          social profile photos onsite at the office in downtown Chicago.',
          date: 'February 21, 2015',
          image_url: "#{CDN_CASE_STUDIES_PATH}salesforce.jpg"
      },

      'slalom' => {
          id: 'slalom',
          title: 'Slalom Consulting - Rendezvous',
          description: '
    Slalom Consulting is a business and technology consulting firm with offices nation wide. Each local office rewards its
    employees with an annual retreat whose theme, details, and location are left to the individual office and changes every year.',
          date: 'June 01, 2011',
          image_url: "#{CDN_CASE_STUDIES_PATH}slalom.jpg"
      }

  }


  def index
    @background_images = BACKGROUND_IMAGES_ARRAY.shuffle!
    @background_phrases = BACKGROUND_PHRASES.map {|string| 'phrases/' + string}
    @studies = [CASE_STUDIES['salesforce']]
  end

end
