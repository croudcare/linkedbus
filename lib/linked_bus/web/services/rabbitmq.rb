require 'rabbitmq/http/client'
require 'uri'

module RabbitMQ
  module HTTP
    class Client
      def publish(exchange, vhost, message, routing_key, properties = {})
        body =  {properties: properties, routing_key: routing_key, payload: message, payload_encoding: "string" }
        response = @connection.post("/api/exchanges/#{uri_encode(vhost)}/#{uri_encode(exchange)}/publish") do |req|
          req.headers['Content-Type'] = "application/json"
          req.body = MultiJson.dump(body)
        end
        decode_resource(response)[:routed] == true
      end
    end
  end
end

module LinkedBus
  module Service
    class RabbitMQ

      def self.endpoint
        @endpoint ||= URI::HTTP.build({:host => LinkedBus.config.host, port: 15672}).to_s
      end

      def self.client
        @client ||= ::RabbitMQ::HTTP::Client.new(endpoint, :username => LinkedBus.config.user, :password => LinkedBus.config.pass)
      end

      def self.queues
        linkedbus_queues = LinkedBus::Subscribers.queue_names
        client.list_queues(LinkedBus.config.vhost).select do |queue|
          linkedbus_queues.include?(queue.name)
        end
      end

      def self.queue_info(name)
        client.queue_info(LinkedBus.config.vhost, name)
      end

      def self.bindings(name)
        bindings = client.list_queue_bindings(LinkedBus.config.vhost, name)
        bindings.select {  |bind| bind.source == LinkedBus.config.exchange  }
      end

      def self.alive?
        client.aliveness_test(LinkedBus.config.vhost)
      end

      def self.publish(keys, message, options = {})
      return false if keys.nil? || keys.empty?
        keys.each do |key| 
          client.publish(LinkedBus.config.exchange, LinkedBus.config.vhost, message, key, options)
        end
      end

    end
  end
end