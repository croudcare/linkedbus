require 'bunny'

module LinkedBus
  module Spec
    class Publisher
      attr_accessor :user, :password, :vhost
      def initialize(user, password, vhost)
        @user = user
        @password = password
        @vhost = vhost
        setup!
      end

      def publish(exchange, key, message)
        broker_exchange(exchange).publish(message, routing_key: key)
      end

      private
      def setup!
        @connection = Bunny.new(:user => user, :password => password, :vhost => vhost)
        @connection.start
      end

      def broker_exchange(name)
        @broker_exchange = @connection.create_channel.topic(name)
      end
    end
  end
end