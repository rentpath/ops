ENV['RAILS_ENV'] = ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'ops'
require 'rack/test'
require 'pry'

def app
  @app ||= Rack::Builder.parse_file(File.expand_path('../support/config.ru', __FILE__)).first
end

Ops.setup do |config|
  config.file_root = File.expand_path('../support/sample_deploy/', __FILE__)
  config.environment = ENV['RACK_ENV']
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.order = :random
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end
end
