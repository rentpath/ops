ENV['RAILS_ENV'] = ENV['RACK_ENV'] ||= 'test'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :controller

  config.color = true
  config.tty = true

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

def app
  @app ||= RailsAppSample::Application
end
