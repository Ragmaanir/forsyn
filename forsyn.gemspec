# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'forsyn/version'

Gem::Specification.new do |s|
  s.name        = 'forsyn'
  s.version     = Forsyn::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ragmaanir"]
  s.email       = ["ragmaanir@gmail.com"]
  s.homepage    = "http://github.com/ragmaanir/forsyn"
  s.summary     = "Alerting framework to define alerts on events"
  s.description = ""

  s.required_rubygems_version = "~> 2.2"
  s.required_ruby_version     = "~> 2.1"
  s.rubyforge_project         = "forsyn"

  s.files        = Dir.glob("lib/**/*") + %w(README.txt)
  s.test_files   = Dir.glob("spec/**/*_spec.rb")
  s.require_path = 'lib'

  s.add_runtime_dependency 'activesupport', '>= 3.2'
  s.add_runtime_dependency 'eventmachine', '~> 1.0'
  s.add_runtime_dependency 'em-synchrony', '~> 1.0'
  s.add_runtime_dependency 'em-http-request', '~> 1.0'
  s.add_runtime_dependency 'elasticsearch-transport', '~> 1.0'
  s.add_runtime_dependency 'elasticsearch-api', '~> 1.0'
  s.add_runtime_dependency 'faraday', '~> 0.9'

  s.add_development_dependency "rspec", '~> 3.0'
  s.add_development_dependency 'wrong', '~> 0.7'
  s.add_development_dependency 'minitest-stub-const', '~> 0.3'
  s.add_development_dependency 'timecop', '~> 0.7'

  s.add_development_dependency 'pry', '~> 0.9'
  s.add_development_dependency 'binding_of_caller', '~> 0.7'
end
