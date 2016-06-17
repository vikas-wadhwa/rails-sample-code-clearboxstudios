require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  #Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
   Bundler.require(:default, :assets, Rails.env)
end

module ClearBoxApp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += %W(#{config.root}/initializers/custom)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    #config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    ##################################################################################################
    # ADDED BY CLEARBOXSTUDIOS.COM DEVELOPERS
    ##################################################################################################

    # route error handling to errors controller
    config.exceptions_app = self.routes

    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = { :host => "http://www.clearboxstudios.com" }
    config.assets.initialize_on_precompile = false
    config.assets.prefix = "/assets"
    #config.action_controller.asset_host = "http://www%d.clearboxstudios.com"
    config.action_mailer.asset_host = config.action_controller.asset_host

    config.assets.paths << Rails.root.join("public","plugins","animate").to_s
    config.assets.paths << Rails.root.join("public","plugins","imagesloaded-master").to_s
    config.assets.paths << Rails.root.join("public","plugins","fontello", "font").to_s
    config.assets.paths << Rails.root.join("public","plugins","fullcalendar-1.6.1","fullcalendar").to_s

    config.assets.precompile += ["home.js","image-crop.js","image-gallery.js","invoices.js", "media.js","photo-crop.js", "photo-editable-context-menu.js", "profiles.js","profile-edit.js", "portfolio.js","tasks.js","rotating_slider.js", "video-editable-context-menu.js", "video-player-modal.js", "video-upload.js"]
    config.assets.precompile += ["about.css","accounts.css", "autocomplete.css","contact.css", "case_studies.css", "custom-magnific.css", "custom-flowplayer.js", "events.css", "downloads.css","dashboard.css","home.css","invoices.css", "media.css","photo_crop.css","photo_preview.css","profiles.css","projects.css","portfolio.css","staff.css","tasks.css","variables.css", "user_video.css"]
    config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif] 

  end
end
