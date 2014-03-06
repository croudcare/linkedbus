require 'linked_bus/exchange'
require 'linked_bus/subscriber'


class LinkedBus::Exchanges::DSL

  def initialize(manager)
    @manager = manager
  end

  def topic(name, options = {}, &block)
    raise "DSL Exchange must pass a block" unless block_given?
    exchange = LinkedBus::TopicExchange.new(name, options)
    exchange_dsl = ExchangeDSL.new(@manager)
    block.call(exchange_dsl)
    exchange_dsl.subscribers.each do |sub|
      exchange.subscribe(sub)
    end
    @manager.register exchange
  end

  class ExchangeDSL

    attr_reader :subscribers

    def initialize(manager)
      @manager  = manager
      @subscribers = []
    end

    def subscribe(routing_key, queue_name, handler, options = {})
      routing_key = [routing_key] unless routing_key.is_a? Array 
      Array.new(routing_key).each do |key|
        @subscribers.push LinkedBus::Subscriber.new(key, queue_name, handler, options)
      end
    end
  end
  
end
