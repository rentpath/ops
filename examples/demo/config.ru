#!/usr/bin/env ruby
require 'logger'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../../lib'
$LOAD_PATH.unshift File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))
require 'app'
require 'ops'

use Rack::ShowExceptions

Ops.setup do |config|
  config.file_root = './sample_deploys/4123'
  config.environment = ENV['RACK_ENV']
end

run Rack::URLMap.new \
  "/"       => Demo::App.new,
  "/ops" => Ops::Server.new
