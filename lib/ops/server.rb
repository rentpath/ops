require 'sinatra/base'
require 'ops/server/helpers'

module Ops
  class Server < Sinatra::Base
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
      puts @headers
      haml :version
    end

    get '/heartbeat/?' do
      'OK'
    end
  end
end
