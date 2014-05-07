Ops
===

[![Code Climate](https://codeclimate.com/github/primedia/ops.png)](https://codeclimate.com/github/primedia/ops)

This gem provides standardized support for obtaining environment, version, and heartbeat information from Sinatra or Rails-based web applications.

**You will likely want to block or restrict access to the `/ops/env` route since this exposes all of your currently set environment variables (e.g. any API keys set as env vars) to the public.**

Typical usage:

```
/ops/version      - displays version info as HTML
/ops/version.json - displays version info as JSON
/ops/heartbeat    - returns 'OK' if the app is alive
/ops/env          - display the currently set environment variables
/ops/health_check - displays the status for the provided app dependencies
```

This gem replaces the now-deprecated [ops_routes](https://github.com/primedia/ops_routes).

Installation
------------

### For Rails 3 apps:

1. Add the gem to your project's Gemfile:
    ```ruby
    gem 'ops'
    ```

2. Add the following to application.rb:

    ```ruby
    Ops.setup do |config|
      config.file_root = Rails.root
      config.environment = Rails.env
      config.dependencies = {
        dependency_name: proc { dependency_check }
      }
    end
    ```

3. mount the gem in routes.rb:

    ```ruby
    mount Ops.new, :at => "/ops"
    ```

### For Sinatra apps:

1. Add the gem to your project's Gemfile:

    ```ruby
    gem 'ops'
    ```

2. Add the following to config.ru:

    ```ruby
    require 'ops'

    #...

    Ops.setup do |config|
      config.file_root = File.dirname __FILE__
      config.environment = ENV['RACK_ENV']
      config.dependencies = {
        dependency_name: proc { dependency_check }
      }
    end

    run Rack::URLMap.new \
      "/"    => YourAppClass,
      "/ops" => Ops.new
    ```

    ```ruby
    # Implementation within rack cascade:
    run Rack::Cascade.new([
      NewHomeGuide,
      ListingSearch::App,
      Ops.rack_app('/ops')
    ])
    ```

Adding Custom Heartbeats
------------------------

Additionally, you can specify custom heartbeat monitoring pages as follows:

```ruby
Ops.add_heartbeat :mysql do
  conn = ActiveRecord::Base.connection
  migrations = conn.select_all("SELECT COUNT(1) FROM schema_migrations;") 
  conn.disconnect!
end
```

The mysql example shown above would be accessed at ops/heartbeat/mysql. The heartbeat page will return a `200 ‘OK’` as long as the provided block returns true. If an error is raised, the heartbeat does not exist, or the block returns a falsey value, a `500` will be returned instead.
