require 'linked_bus/subscriber'

class LinkedBus::Subscribers::DSL

  def initialize(manager)
    @manager = manager
  end
  
  def subscribe(routing_key, queue_name, handler, options = {})
    routing_key = [routing_key] unless routing_key.is_a? Array 
    Array.new(routing_key).each do |key|
      @manager.register LinkedBus::Subscriber.new(key, queue_name, handler, options)
    end
  end
end
