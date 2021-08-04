# frozen_string_literal: true

require_relative './lib/apia/insomnia/version'

Gem::Specification.new do |s|
  s.name          = 'apia-insomnia'
  s.description   = 'A Raid schema generator for Insomnia.'
  s.summary       = 'This gem provides a tool for generating an Insomnia compatible schema for a Apia API.'
  s.homepage      = 'https://github.com/krystal/apia-insomnia'
  s.version       = Apia::Insomnia::VERSION
  s.files         = Dir.glob('VERSION') + Dir.glob('{lib}/**/*')
  s.require_paths = ['lib']
  s.authors       = ['Adam Cooke']
  s.email         = ['adam@k.io']
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'rack'
  s.required_ruby_version = '>= 2.6'
end
