BothAreTotallyEnraged::Application.configure do
  
  PAPERCLIP_STORAGE_OTPIONS = {}
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' } #for devise authentication
  ENV['RECAPTCHA_PUBLIC_KEY'] = '6LeEmMUSAAAAAFWWXukV_aFvZiix7NiEWIUIR3jb'
  ENV['RECAPTCHA_PRIVATE_KEY'] = '6LeEmMUSAAAAAM5bHJSf1OZXtfao55FTdSnj8mpp'
  #TODO: add the equivalent of this for test and production environments
  
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't sends
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  Paperclip.options[:command_path] = "C:/PROGRA~1/ImageMagick-6.7.0-Q16"
end

