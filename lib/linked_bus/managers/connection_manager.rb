require 'linked_bus/notifier/error'

class LinkedBus::ConnectionManager

  attr_accessor :on_failure_callback, :on_loss_callback, :on_error_callback, :on_connection_interruption

  def initialize
    @on_failure_callback = proc do 
      LinkedBus::Notifier::Error.instance.error "TCP Connection Failure detected."
    end

    @on_loss_callback = proc do |connection, settings|
      LinkedBus::Notifier::Error.instance.error("Reconnecting. Connection Interruption detected.")
      @connection.reconnect(false, 5) 
    end

    @on_error_callback = proc do |conn, connection_close| 
      LinkedBus::Notifier::Error.instance.error "Connection Manager error #{conn}"
    end

    @on_connection_interruption = proc do |conn, connection_close| 
      LinkedBus::Notifier::Error.instance.error "Connection Interrupted"
    end
  end

  def connect(args = default_connection, &callback)
    AMQP.connect(args) do |connection|
      @connection = connection
      register_errors!
      callback.call(connection) 
    end
  end

  def disconnect(&block)
    return @connection.disconnect(&block) rescue nil
    block.call
  end

  private

    def default_connection
      { 
        host: LinkedBus.config.host, 
        user: LinkedBus.config.user, 
        pass: LinkedBus.config.pass,
        vhost: LinkedBus.config.vhost,
        heartbeat: LinkedBus.config.heartbeat
      }
    end

    def register_errors!
      on_failure
      on_loss
      on_error
      on_interruption
    end

    def on_interruption
      @connection.on_connection_interruption &@on_connection_interruption
    end

    def on_failure
      @connection.on_tcp_connection_failure &@on_failure_callback
    end

    def on_loss
      @connection.on_tcp_connection_loss &@on_loss_callback
    end

    def on_error
      @connection.on_error &@on_error_callback
    end

end