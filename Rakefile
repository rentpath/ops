require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.warn e.message
  $stderr.warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/ops/**/*_spec.rb'
end

task default: :spec
