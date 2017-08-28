require './lib/ops'

use Rack::ShowExceptions

run Rack::URLMap.new \
  '/ops' => Ops.new
