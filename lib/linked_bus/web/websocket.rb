require 'em-websocket'
require 'linked_bus/logging'

module LinkedBus

  class WebSocket

    class Manager

      def self.start(port)
        @server ||= LinkedBus::WebSocket.new.tap do |ws|
          ws.start(port)
        end
      end

      def self.stop
        @server.stop
      end

      def self.send_message(identity, message)
        @server.publish(identity, message)
      end

    end
    
    class NullIdentity
      def self.send(*);end
    end

    def initialize
      @connections = Hash.new { |k,v|
        LinkedBus::Logging.info("WS identity not found [#{k}]")
        NullIdentity
      }
    end

    def start(port)
      @server = EventMachine::WebSocket.run(:host => '0.0.0.0', :port =>  port) do |ws|
        ws.onopen  { |handshake|
          sid = handshake.query["identity"]
          @connections[sid] = ws

          ws.onmessage  { |msg| on_message(msg)}
          ws.onclose    { on_close(sid) }
          ws.onerror    { |error| on_error(error, ws) }
          LinkedBus::Logging.info("[WS] Connection opened, #{@connections.length} connections alive")
        }

      end
    end

    # Do nothing. The default behavior for WebSocket stop is close EM.
    # The linkedbus will close the EM in the end of the process
    def stop; end

    def publish(identity, message)
      @connections[identity].send("#{message}")
    end

     # Im not handling received messages, just ignoring on purpose
    def on_message(msg)
      LinkedBus::Logging.info("WS received a new message")
    end

    def on_close(sid)
      @connections.delete(sid)
      LinkedBus::Logging.info("[WS] Close channel #{sid}, #{@connections.length} connections remaining")
    end

    def on_error(error, ws)
      if error.kind_of?(EM::WebSocket::WebSocketError)
        LinkedBus::Logging.fatal("WS error #{error}")
      end
    end

  end
end