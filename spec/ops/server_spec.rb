require 'spec_helper'
require 'rack/test'
require 'ops/server'

class ReliableConfigService
  def call(options = {})
    { foo: 'bar' }
  end
end

class ErrorProneConfigService
  def call(options = {})
    raise StandardError, 'oops'
  end
end

describe Ops::Server do
  include Rack::Test::Methods

  def app
    Ops::Server
  end

  def enable_config_service(adapter)
    Ops.setup do |config|
      config.config_service_adapter = adapter
    end
  end

  def disable_config_service
    Ops.setup do |config|
      config.config_service_adapter = nil
    end
  end

  describe 'GET /config' do
    describe 'when config service is enabled' do
      it 'responds with response from config service' do
        enable_config_service(ReliableConfigService.new)
        get '/config'
        expect(last_response.status).to eq(200)
        body = JSON.parse(last_response.body)
        expect(body).to eq('foo' => 'bar')
      end

      it 'responds with an error from config service' do
        enable_config_service(ErrorProneConfigService.new)
        get '/config'
        expect(last_response.status).to eq(422)
        body = JSON.parse(last_response.body)
        expect(body).to eq('error' => 'oops')
      end
    end

    describe 'when config service is disabled' do
      before do
        disable_config_service
      end

      it 'responds with an error' do
        get '/config'
        expect(last_response.status).to eq(501)
      end
    end
  end
end
