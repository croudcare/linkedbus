# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'linked_bus/version'

Gem::Specification.new do |spec|
  spec.name          = "linked_bus"
  spec.version       = LinkedBus::VERSION
  spec.authors       = ['Pedro Cunha', 'Thiago Dantas']
  spec.email         = ['pkunha@gmail.com', 'thiago.teixeira.dantas@gmail.com']
  spec.description   = %q{Easy way to subscribe on RabbitMQ}
  spec.summary       = %q{Subscribe to RabbitMQ queues using EventMachine}
  spec.homepage      = 'https://github.com/pedrocunha/linked_bus'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 10.1.1'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'evented-spec', "~> 0.9"
  spec.add_development_dependency 'multi_json'
  spec.add_development_dependency 'bunny'
  spec.add_development_dependency 'em-spec'


  spec.add_dependency 'em-websocket'
  spec.add_dependency 'amqp', '~> 1.3.0'
  spec.add_dependency 'thin', '~> 1.6.1'
  spec.add_dependency 'sinatra', '~> 1.4.4'
  spec.add_dependency 'rack-fiber_pool', '~> 0.9.3'
  spec.add_dependency 'rabbitmq_http_api_client', '~> 1.0.0'
end
