require 'sinatra/base'
require 'server/helpers'

module Ops
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))
    set :views,  "#{dir}/server/views"
    set :public_folder, "#{dir}/server/public"
    set :static, true

    helpers Ops::Server::Helpers

    get '/version' do
      @version = VersionPage.new request.headers
      #render text: Ops.check_version(request.headers)
    end

    get '/heartbeat(/:name)' do
      @heartbeat = Heartbeat.new
      #response.content_type = "text/plain"
      #render Ops.check_heartbeat(params[:name])
    end

    get '/configuration' do
      render text: Ops.check_configuration
    end
  end
end
