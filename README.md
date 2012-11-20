Ops
===

This gem provides standardized support for obtaining version and heartbeat information from Sinatra or Rails-based web applications.

Typical usage:

	/ops/version 		- displays version info as HTML
	/ops/version.json	- displays version info as JSON
	/ops/heartbeat		- returns 'OK' if the app is alive

This gem replaces the now-deprecated [ops_routes](https://github.com/primedia/ops_routes).


Installation
------------

### For Rails 3 apps:

1. Add the gem to your project's Gemfile:
	
		gem 'ops'

2. Add the following to application.rb:

        Ops.setup do |config|
          config.file_root = Rails.root
          config.environment = Rails.env
    	end
    
3. mount the gem in routes.rb:

		mount Ops.new, :at => "/ops"
  
### For Sinatra apps:

1. Add the gem to your project's Gemfile:
	
		gem 'ops'

2. Add the following to config.ru:

		require 'ops'

		Ops.setup do |config|
		  config.file_root = File.dirname __FILE__
		  config.environment = ENV['RACK_ENV'] 
		end
		
		run Rack::URLMap.new \
		  "/"       => YourAppClass,
		  "/ops" => Ops.new		