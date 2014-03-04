require 'linked_bus/web/app'
require 'linked_bus/web/websocket'

module LinkedBus

   class WebModule

    class NullWebModule
      def start; end
      def stop; end
    end
    
    def self.NULL
      NullWebModule.new
    end
  
    def initialize(config)
      @config = config.web
      @webApplication = LinkedBus::WebApp.new
    end

    def start
      Thin::Logging.logger = LinkedBus::Logging
      @server = Thin::Server.start( @config.host, @config.port, @webApplication, :signals => false)
      @webSocketServer = LinkedBus::WebSocket::Manager.start(@config.ws_port)
    end

    def stop
      Logging.info "Stopping WebModule"
      @server.stop rescue nil 
      @webSocketServer.stop rescue nil
    end

  end
end
