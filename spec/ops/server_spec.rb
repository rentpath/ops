require 'spec_helper'
require 'rack/test'
require 'ops/server'

class ReliableConfigService
  def get_config(options)
    { foo: 'bar' }
  end
end

class ErrorProneConfigService
  def get_config(options)
    raise StandardError, 'oops'
  end
end

describe Ops::Server do
  include Rack::Test::Methods

  def app
    Ops::Server
  end

  def enable_config_service(adapter_class_name)
    Ops.setup do |config|
      config.use_config_service = true
      config.config_service_adapter = adapter_class_name
    end
  end

  def disable_config_service
    Ops.setup do |config|
      config.use_config_service = false
      config.config_service_adapter = nil
    end
  end

  describe 'GET /config' do
    describe 'when config service is enabled' do
      it 'responds with response from config service' do
        enable_config_service(ReliableConfigService)
        get '/config'
        last_response.status.should == 200
        body = JSON.parse(last_response.body)
        body.should == { 'foo' => 'bar' }
      end

      it 'responds with an error from config service' do
        enable_config_service(ErrorProneConfigService)
        get '/config'
        last_response.status.should == 422
        body = JSON.parse(last_response.body)
        body.should == { 'error' => 'oops' }
      end
    end

    describe 'when config service is disabled' do
      before do
        disable_config_service
      end

      it 'responds with an error' do
        get '/config'
        last_response.status.should == 501
      end
    end
  end
end
