# frozen_string_literal: true

require_relative './lib/rapid/insomnia/version'

Gem::Specification.new do |s|
  s.name          = 'rapid-insomnia'
  s.description   = 'A Raid schema generator for Insomnia.'
  s.summary       = 'This gem provides a tool for generating an Insomnia compatible schema for a Rapid API.'
  s.homepage      = 'https://github.com/krystal/rapid'
  s.version       = Rapid::Insomnia::VERSION
  s.files         = Dir.glob('VERSION') + Dir.glob('{lib}/**/*')
  s.require_paths = ['lib']
  s.authors       = ['Adam Cooke']
  s.email         = ['adam@krystal.uk']
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'rack'
  s.required_ruby_version = '>= 2.6'
end
