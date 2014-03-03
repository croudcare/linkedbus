require 'eventmachine'

class LinkedBus::Launcher

  def initialize(config, web, broker)
    @config = config
    @webmodule =  web
    @broker    =  broker
  end

  def start(&block)
    EM.run do
      stop = proc { self.stop }
      Signal.trap("TERM", &stop)
      Signal.trap("INT",  &stop)
      @broker.start {
        @webmodule.start 
        block.call if block_given?
      }
    end
  end

  def reconnect!(&block)
    return unless @broker
    block ||= proc {}
    @broker.reconnect!(&block)
  end

  def stop
    LinkedBus::Logging.info "Stopping all LinkedBus Modules"
    @broker.stop {
      LinkedBus::Logging.info "Broker Stopped"
      @webmodule.stop
      EM.stop if EM.reactor_running?
    }
  end

  def self.start(config)
    new(config).start
  end

end

require 'linked_bus/broker'
require 'linked_bus/web/webmodule'
