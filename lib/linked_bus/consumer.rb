require 'amqp'
require 'linked_bus/message'
require 'objspace'

# class Collected
#   def self.collected
#     proc { |id| puts "Collected sorry mate" }
#   end
# end

class LinkedBus::Consumer

  def self.register(channel, exchange, subscribers)
    subscribers = [subscribers] unless subscribers.is_a? Enumerable
    subscribers.each do |subscriber|
      LinkedBus::Logging.info("Registering subscriber #{subscriber}")
      new(channel, exchange).register(subscriber)
#    ObjectSpace.define_finalizer(x, Collected.collected)
    end
  end

  attr_accessor :channel, :exchange
  def initialize(channel, exchange)
    @channel  = channel
    @exchange = exchange
  end

  def register(subscriber)
    queue = create_queue(subscriber.queue_name, subscriber.options)
    bind_queue(queue, subscriber.key)
    subscribe(queue, subscriber.handler)
  end

  private
  def create_queue(name, options)
    channel.queue(name, options)
  end

  def bind_queue(queue, key)
    queue.bind(exchange, {routing_key: key})
  end

  def subscribe(queue, handler)
    consumer = ::AMQP::Consumer.new(channel, queue)
    consumer.consume.on_delivery do |metadata, payload|
      begin
        message = LinkedBus::Message.new(payload, metadata)
        handler.call(message)
      rescue StandardError => se
        raise "Exception raised in handler [ #{se.message} ]" if $DISABLE_HANDLER_EXCEPTION
        LinkedBus::Notifier::Error.instance.error "Subscriber Failure #{message}"
      ensure
        metadata.ack
      end
    end    
  end
 
end