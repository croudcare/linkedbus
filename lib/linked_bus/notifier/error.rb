require 'linked_bus/logging'
require 'linked_bus/notifier'
require 'singleton'

class LinkedBus::Notifier::Error
  include Singleton

  def initialize
    @manager = LinkedBus::Notifier.new
    @manager.handler(default_handler) 
  end

  def error(message)
    LinkedBus::Logging.error "[ErrorNotifier] registering new error [#{message}]"
    @manager.register(message)
  end

  private
  
    def default_handler
      proc { |message| LinkedBus::Logging.error "Error Notifier [default handler]: #{message}"}
    end

end
