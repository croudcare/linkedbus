require 'bunny'

module LinkedBus
  module Spec
    class Publisher
      attr_accessor :user, :password, :vhost, :exchange
      def initialize(user, password, vhost, exchange)
        @user = user
        @password = password
        @vhost = vhost
        @exchange = exchange
        setup!
      end

      def publish(key, message)
        broker_exchange.publish(message, routing_key: key)
      end

      private
      def setup!
        @connection = Bunny.new(:user => user, :password => password, :vhost => vhost)
        @connection.start
      end

      def broker_exchange
        @broker_exchange = @connection.create_channel.topic(exchange)
      end
    end
  end
end