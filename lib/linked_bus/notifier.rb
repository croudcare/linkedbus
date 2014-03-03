require 'eventmachine'
require 'linked_bus/logging'

class LinkedBus::Notifier

  def initialize
    @buffer = []
    @handlers = []
    @defered = false
  end

  def register(message)
    @buffer.push([Time.now, message].join(" \n"))
    defer_send
  end

  def handler(handler)
    @handlers.push handler
  end

  private

  def defer_send
    return if @defered
    LinkedBus::Logging.info "Defered messages to be sent in 10 seconds"
    callback = proc { 
      LinkedBus::Logging.info "Clearing notifier buffer"
      @handlers.each do |handler|
        handler.call @buffer.join(" ")
      end
      @buffer.clear
      @defered = false 
    }
    ::EM.add_timer(10, &callback)
    @defered = true
  end

end

