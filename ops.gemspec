# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ops/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Pelz-Sherman", "Colin Rymer"]
  gem.email         = [""]
  gem.description   = gem.summary = ""
  gem.homepage      = "http://github.com/primedia/ops"
  gem.license       = ""

  gem.executables   = []
  gem.files         = `git ls-files | grep -v myapp`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "ops"
  gem.require_paths = ["lib"]
  gem.version       = Ops::VERSION
  gem.add_dependency             'haml', '~> 3.1.7'
  gem.add_dependency             'sinatra'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
