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

    get '/version/?' do
      @version = Revision.new request_headers
      @previous_versions = @version.previous_versions
      @headers = @version.headers
      respond_to do |wants|
        wants.html { erb :version }
        wants.json do
          JSON.generate({
            version: @version.version_or_branch,
            previous_versions: @previous_versions,
            headers: @headers
          })
        end
      end
    end

    get '/heartbeat/?' do
      'OK'
    end

    get '/heartbeat/:name/?' do
      name = params[:name]
      if Heartbeat.check name
        "#{name} is OK"
      else
        status 503
        "#{name} does not have a heartbeat"
      end
    end
  end
end

