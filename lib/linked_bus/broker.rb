require 'amqp'
require 'linked_bus/exchanges'
require 'linked_bus/consumer'
require 'linked_bus/logging'
require 'linked_bus/notifier/error'
require 'linked_bus/managers/connection_manager'
require 'linked_bus/managers/channel_manager'

class LinkedBus::Broker

  def initialize(conf)
    @conf = conf
    @connectionManager = LinkedBus::ConnectionManager.new
    @started = false
  end

  def start(&block)
    block ||= proc {}
    @connectionManager.connect do |connection|
      connection_callback(connection, &block)
      LinkedBus::Logging.info "Broker Connected !"
    end
    @started = true
  end

  def stop(&block)
    block ||= proc { }
    @connectionManager.disconnect(&block)
    LinkedBus::Logging.info("Stopping Broker")
    ensure
      @started = false
  end

  def reconnect!(&block)
    block ||= proc {}
    stop { 
      start(&block)
    } 
  end

  def subscribe(exchange)
    callback = proc {
      @channelManager.channel do |ch|
        consumer = LinkedBus::Consumer.new(ch,exchange)
        exchange.subscribers.each do |subscriber|
          consumer.register(subscriber)
        end
      end    
    }
    @started ? callback.call : start(&callback)
  end

  private
  # name your callbacks to avoid hell
  # never use node or async codes ( http://callbackhell.com/ )
  
  def connection_callback(connection, &callback)
    @channelManager = LinkedBus::ChannelManager.new(connection)
    @channelManager.channel do |channel|
      LinkedBus::Consumer.register(channel, LinkedBus::Exchanges.instance)
      callback.call
    end
  end

end
