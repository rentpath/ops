require 'ops/config'
require 'ops/version'
require 'ops/revision'
require 'ops/heartbeat'
require 'ops/server'

module Ops
  class << self
    def new
      Server.new
    end

    def rack_app(path)
	    Rack::Builder.new {
				map(path) { run Ops.new }
			}.to_app
    end
  end
end

