require 'ops/config'
require 'ops/version'
require 'ops/revision'
require 'ops/heartbeat'
require 'ops/server'

begin
  require 'configuration_client'
rescue LoadError
  # Confusion configuration service is unavailable
end

module Ops
  class << self
    def new(path = '/')
      Rack::Builder.new {
        map(path) { run Server.new }
        if Ops.use_confusion?
          map(Ops.confusion_path(path)) { run ConfigurationClient::Middleware.new }
        end
      }.to_app
    end

    def rack_app(path)
      Ops.new(path)
    end

    def use_confusion?
      Ops.config.use_confusion && defined?(::ConfigurationClient)
    end

    def confusion_path(prefix)
      File.join(prefix, 'confusion')
    end
  end
end

