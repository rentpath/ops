Ops
===

[![Code Climate](https://codeclimate.com/github/primedia/ops.png)](https://codeclimate.com/github/primedia/ops)

This gem provides standardized support for obtaining version and heartbeat information from Sinatra or Rails-based web applications.

Typical usage:

```
/ops/version      - displays version info as HTML
/ops/version.json - displays version info as JSON
/ops/heartbeat    - returns 'OK' if the app is alive
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
    end

    run Rack::URLMap.new \
      "/"    => YourAppClass,
      "/ops" => Ops.new
    ```
If using an app that implements Rack Cascade, you will want to use version 0.0.2 of the gem:

    run Rack::Cascade.new([
      Ops::Server
    ])

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
