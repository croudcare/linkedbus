require 'eventmachine'
require 'linked_bus/logging'

class LinkedBus::Notifier

  attr_reader :buffer
  def initialize(delay = 10)
    @delay = delay
    @buffer = []
    @defered = false
  end

  def register(message)
    @buffer.push([message].join(" \n"))
    defer_send
  end

  def handler=(handler)
    raise "Notifier Handler must respond_to? :call" unless handler.respond_to?(:call)
    @handler = handler 
  end

  def handler
    @handler || proc do |buffer|
      LinkedBus::Logging.info "Clearing notifier buffer"
      @handler.call @buffer.join(" ")
    end
  end

  private

  def defer_send
    return if @defered
    LinkedBus::Logging.info "Defered messages to be sent in #{@delay} seconds"
    callback = proc do
      handler.call(@buffer) rescue nil
      @buffer.clear;
      @defered = false;
    end
    ::EM.add_timer(@delay, callback)
    @defered = true
  end

end

