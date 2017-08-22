ENV['RAILS_ENV'] ||= 'development'
require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require 'rails'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module RailsAppSample
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.eager_load = false

    config.color = true
    config.tty = true

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    config.active_support.deprecation = :log

    Ops.setup do |config|
      config.file_root = File.join(Rails.root, '/../sample_deploys/4123')
      config.environment = Rails.env

      # Optionally use a configuration service
      # config.config_service_adapter = something_that_responds_to_call
    end

  end
end
