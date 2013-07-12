# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/ops/**/*_spec.rb"
end

desc "Executes the example tests"
task "test:examples" do
  %w[rails3 sinatra].each do |ex|
    puts "\n*** Running tests for #{ex}... ***\n"
    puts `cd #{File.join(File.dirname(__FILE__),'examples',ex)}; bundle check; bundle exec rake test:ops`
  end
end

task :default => :spec
