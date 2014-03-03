require 'linked_bus/subscribers'
require 'linked_bus/web/websocket'
require 'linked_bus/web/services/rabbitmq'
require 'securerandom'

class Time
  def to_ms
    (self.to_f * 1000.0).to_i
  end
end

module LinkedBus
  module Service

    class AutoTestHandler

      def self.call(message)
        LinkedBus::WebSocket::Manager.send_message *parse_msg(message)
      end

      private
        def self.parse_msg(message)
          start_at, identity = message.payload.split("|")
          end_at = Time.now.to_ms
          [identity, (end_at - start_at.to_i)]
        end

    end
   
    class Testify

      attr_accessor :handler, :routing_key, :queue_name
      def initialize(routing_key = "linkedbus.auto.test", queue_name= "auto.linkedbus.test-#{SecureRandom.hex(10)}", handler = AutoTestHandler)
        @handler      = handler
        @routing_key  = routing_key
        @queue_name   = queue_name
        register_test_queue!
      end
      
      def register_test_queue!
        subscriber = LinkedBus::Subscriber.new(routing_key, queue_name, handler, {:auto_delete => true, :exclusive => true})
        LinkedBus.broker.subscribe(subscriber)
      end
      private :register_test_queue!

      def self.queue_name
        __instance__.queue_name
      end

      def self.__instance__
        @__instance__ ||= new
      end

      def self.publish(identity)
        Service::RabbitMQ.publish(["linkedbus.auto.test"],"#{Time.now.to_ms}|#{identity}")        
      end

    end

  end
end