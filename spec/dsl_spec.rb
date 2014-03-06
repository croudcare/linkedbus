require 'spec_helper'

require 'linked_bus/subscribers/dsl'

class ManagerStub
  attr_accessor :exchanges

  def initialize
    @exchanges = []
  end

  def register(obj)
    @exchanges  << obj
  end

  def clear!
    @exchanges.clear
  end
end

describe LinkedBus::Exchanges::DSL do 

  before(:each) do 
    @manager = ManagerStub.new
  end

  after(:each) do 
    @manager.clear!
  end

  subject { LinkedBus::Exchanges::DSL.new(@manager) }

  it 'responds to topic' do 
    expect(subject).to respond_to(:topic)
  end

  it 'initializes with a manager' do 
    expect(@manager.exchanges).to be_empty
  end

  it 'raises when try to create a exchange without a block' do 
    expect { subject.topic('topic_name') }.to raise_error
  end

  it 'preserves exchange properties' do 
    subject.topic('name', { durable: true }) {}
    exchange = @manager.exchanges.first
    expect(exchange.type).to eql(:topic)
    expect(exchange.options).to eql({ durable: true})
  end

  it 'preserve subscriber properties' do 
    handler = proc {}
    
    subject.topic(:topic) do |ex|
      ex.subscribe 'routing.key', 'queue_name', handler, { auto_delete: true}
    end

    exchange = @manager.exchanges.first
    subscriber = exchange.subscribers.first
    expect(subscriber.key).to eql('routing.key')
    expect(subscriber.queue_name).to eql('queue_name')
    expect(subscriber.options).to eql({:auto_delete => true})
    expect(subscriber.handler).to eql(handler)
  end

end