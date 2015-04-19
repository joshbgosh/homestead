BothAreTotallyEnraged::Application.configure do
  
  PAPERCLIP_STORAGE_OPTIONS = {:storage => :s3,
      :s3_credentials => "#{Rails.root}/config/s3_quicktest.yml",
      :path => "/:style/:id/:filename"}
      
  # Settings specified here will take precedence over those in config/application.rb
  #ENV['RECAPTCHA_PUBLIC_KEY'] = 'MY_PUBLIC_KEY'
#ENV['RECAPTCHA_PRIVATE_KEY'] = 'MY_PRIVATE_KEY' 
  #TODO: stick production recaptcha keys here. They're in the file recaptcha_bate.com
  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  
  config.session_store = :active_record_store  #TODO: change to improve performance

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  
  #TODO: Replace with feature flags eventually
  config.comments_enabled = false
  config.signin_enabled = false
end