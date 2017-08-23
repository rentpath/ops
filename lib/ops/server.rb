require 'sinatra/base'
require 'ops/server/helpers'
require 'json'

module Ops
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path('', __FILE__))
    set :views, "#{dir}/server/views"
    # set :views, File.dirname(File.expand_path('/../server/views', __FILE__))

    helpers Ops::Helpers

    def request_headers
      env.each_with_object({}) { |(k, v), headers| headers[k] = v }
    end

    def jsonified_version(version, previous_versions, headers)
      JSON.generate(
        version: version.version_or_branch,
        revision: version.last_commit,
        previous_versions: previous_versions,
        headers: headers
      )
    end

    def json_request?
      !!Array(params['format'] || request.accept).detect { |f| f.to_s =~ /json/ }
    end

    get '/env/?' do
      @env_vars = ENV.sort
      erb :env
    end

    get '/version/?:format?', provides: %i(html json) do
      @version = Revision.new(request_headers)
      @previous_versions = @version.previous_versions
      @headers = @version.headers

      if json_request?
        content_type 'application/json'
        return jsonified_version(@version, @previous_versions, @headers)
      end

      erb :version
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
