require 'sinatra/base'
require 'sinatra/respond_to'
require 'ops/server/helpers'
require 'rabl'
require 'slim'

module Ops
  class Server < Sinatra::Base
    Rabl.register!
    Server.register Sinatra::RespondTo
    Slim::Engine.set_default_options shortcut: { '#' => 'id', '.' => 'class' }
    dir = File.dirname(File.expand_path(__FILE__))
    set :views,  "#{dir}/server/views"
    set :public_folder, "#{dir}/server/public"
    set :static, true

    helpers Ops::Helpers

    def request_headers
      env.each_with_object({}) do |(k,v), headers|
        headers[k.to_sym] = v
      end
    end

    get '/version/?' do
      @version = Revision.new request_headers
      @previous_versions = @version.previous_versions
      @headers = @version.headers
      respond_to do |wants|
        wants.html { slim :version }
        wants.json { render :rabl, :version, format: 'json' }
      end
    end

    get '/heartbeat/?' do
      'OK'
    end
  end
end
