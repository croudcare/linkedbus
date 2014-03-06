require 'singleton'
require 'linked_bus/logging'
require 'linked_bus/exchange'

class LinkedBus::Exchanges
  include Singleton
  include Enumerable

  attr_reader :exchanges

  def initialize
    @exchanges = []
  end

  def each(&block)
    @exchanges.each &block
  end

  def register(exchange)
    @exchanges.push exchange
  end

  def self.register(&block)
    manager = DSL.new(self.instance)
    block.call(manager)
  end

  def clear!
    @exchanges.clear
  end

  def empty?
    @exchanges.empty?
  end

  def self.clear!
    self.instance.clear!
  end

  def self.empty?
    self.instance.empty?
  end

  def self.queue_names
    queues = []
    self.instance.exchanges.each do |exchange|
      exchange.subscribers.each { |s| queues.push(s.queue_name) }
    end
    queues
  end

  def self.names
    self.instance.exchanges.map {|ex| ex.name }
  end

end

require 'linked_bus/subscribers/dsl'
