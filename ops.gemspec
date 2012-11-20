# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ops/version', __FILE__)
require 'date'

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Pelz-Sherman", "Colin Rymer"]
  gem.email         = ["mpelzsherman@primedia.com", "crymer@primedia.com"]
  gem.description   = gem.summary = "Provide ops info endpoints."
  gem.date = Date.today.to_s
  gem.homepage      = "http://github.com/primedia/ops"
  gem.executables   = []
  gem.files         = `git ls-files | grep -v myapp`.split("\n")
  gem.test_files    = `git ls-files -- test/*`.split("\n")
  gem.name          = "ops"
  gem.require_paths = ["lib"]
  gem.version       = Ops::VERSION
  gem.add_dependency             'slim', '~> 1.3.4'
  gem.add_dependency             'sinatra', '~> 1.3.3'
  gem.add_dependency             'sinatra-respond_to', '~> 0.8.0'
  gem.add_dependency             'rabl', '~> 0.7.6'
  gem.add_dependency             'oj', '~> 1.4.5'
end
