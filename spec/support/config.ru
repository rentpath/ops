require './lib/ops'

Ops.setup do |config|
  config.file_root = 'spec/support/sample_deploys/4123'
  config.environment = ENV['RACK_ENV']
end

use Rack::ShowExceptions

run Rack::URLMap.new \
  '/ops' => Ops::Server.new
