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
        linkedbus_queues = LinkedBus::Exchanges.queue_names
        client.list_bindings(LinkedBus.config.vhost).map do |binding|
          if linkedbus_queues.include? binding.destination
            Hashie::Mash.new({name: binding.destination})
          end
        end.compact!.uniq
      end

      def self.queue_info(queue_name)
        client.queue_info(LinkedBus.config.vhost, queue_name)
      end

      def self.bindings(queue_name)
        exchange_names = LinkedBus::Exchanges.names
        client.list_queue_bindings(LinkedBus.config.vhost, queue_name).select do |binding|
          exchange_names.include?(binding.source)
        end
      end

      def self.alive?
        client.aliveness_test(LinkedBus.config.vhost)
      end

      def self.publish(routing_keys, message, options = {})
      return false if routing_keys.nil? || routing_keys.empty?
        routing_keys.each do |exchange, keys|
          keys.each do |key|
            client.publish(exchange, LinkedBus.config.vhost, message, key, options)
          end
        end
      end

    end
  end
end