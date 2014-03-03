# encoding: utf-8

require 'bundler/setup'
Bundler.require(:default, :test)

require "amqp"
require "evented-spec"
require "effin_utf8"
require "multi_json"

EventMachine.kqueue = true if EventMachine.kqueue?
EventMachine.epoll  = true if EventMachine.epoll?

# loading support files
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

LinkedBus.config.logfile = "/dev/null"

RSpec.configure do |config|

  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end