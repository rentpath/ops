ENV['RAILS_ENV'] = ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'ops'
require 'rack/test'
require 'pry'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.order = :random
  Kernel.srand config.seed
end

def app
  @app ||= Rack::Builder.parse_file(File.expand_path('../support/config.ru', __FILE__)).first
end
