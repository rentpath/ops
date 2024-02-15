require File.expand_path('lib/ops/version', __dir__)
require 'date'

Gem::Specification.new do |s|
  s.name = 'ops'
  s.version = Ops::VERSION
  s.summary = 'Provide ops info endpoints.'
  s.license = 'MIT'

  s.description = <<-DESCRIPTION
    This gem provides standardized support for obtaining version and heartbeat information.
    Works with Sinatra or Rails-based web applications.
  DESCRIPTION

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

  s.homepage = 'http://rentpath.github.io/ops/'
  s.files = %w(README.md) + Dir.glob('{lib/**/*}')
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.7.0'

  s.metadata = {
    'rubygems_mfa_required' => 'true'
  }

  s.add_dependency 'json', '>= 1.8'
  s.add_dependency 'sinatra', '>= 3.0.4'
end
