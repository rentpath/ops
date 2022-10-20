require File.expand_path('../lib/ops/version', __FILE__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'ops'
  s.summary     = 'Provide ops info endpoints.'
  s.description = <<-EOF
    This gem provides standardized support for obtaining version and heartbeat information.
    Works with Sinatra or Rails-based web applications.
  EOF
  s.version = Ops::VERSION
  s.license = 'MIT'
  s.authors = [
    'Michael Pelz-Sherman',
    'Colin Rymer',
    'Luke Fender',
    'Pasha Lifshiz'
  ]

  s.email = [
    'mpelzsherman@gmail.com',
    'colin.rymer@gmail.com',
    'lfender6445@gmail.com',
    'plifshiz@gmail.com'
  ]

  s.date          = Date.today.to_s
  s.homepage      = 'http://rentpath.github.io/ops/'
  s.files         = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths = ['lib']

  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'sinatra', '~> 1.2'
end
