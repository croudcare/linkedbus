require 'singleton'
require 'linked_bus/logging'

class LinkedBus::Subscribers
  include Singleton

  include Enumerable

  def initialize
    @subscribers = []
  end

  def each(&block)
    @subscribers.each &block
  end

  def register(subscriber)
    @subscribers.push subscriber
  end

  def self.register(&block)
    manager = DSL.new(self.instance)
    block.call(manager)
  end

  def clear!
    @subscribers.clear
  end

  def empty?
    @subscribers.empty?
  end

  def self.clear!
    LinkedBus::Subscribers.instance.clear!
  end

  def self.empty?
    LinkedBus::Subscribers.instance.empty?
  end

  def self.queue_names
    LinkedBus::Subscribers.instance.map do |sub|
      sub.queue_name
    end 
  end

end

require 'linked_bus/subscribers/dsl'
