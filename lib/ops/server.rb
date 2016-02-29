require 'sinatra/base'
require 'sinatra/respond_to'
require 'ops/server/helpers'
require 'json'

module Ops
  class Server < Sinatra::Base
    Server.register Sinatra::RespondTo
    dir = File.dirname(File.expand_path(__FILE__))
    set :views,  "#{dir}/server/views"

    helpers Ops::Helpers

    def request_headers
      env.each_with_object({}) { |(k,v), headers| headers[k] = v }
    end

    def jsonified_version(version, headers)
      JSON.generate({info: @version.info, previous_info: @version.previous_info, headers: @headers})
    end

    get '/env/?' do
      @env_vars = ENV.sort
      erb :env
    end

    get '/version/?' do
      @version = Revision.new(request_headers)
      @headers = @version.headers

      respond_to do |wants|
        wants.html { erb :version }
        wants.json { jsonified_version(@version, @headers) }
      end
    end

    get '/heartbeat/?' do
      'OK'
    end

    get '/heartbeat/:name/?' do
      name = params[:name]
      if Heartbeat.check(name)
        "#{name} is OK"
      else
        status 503
        "#{name} does not have a heartbeat"
      end
    end

    get '/config/?' do
      if config_adapter = Ops.config.config_service_adapter
        begin
          body(config_adapter.call(params).to_json)
        rescue StandardError => e
          status 422
          body({ 'error' => e.message }.to_json)
        end
      else
        status 501
      end
    end
  end
end

