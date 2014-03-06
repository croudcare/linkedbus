require 'spec_helper'

require 'linked_bus/exchange'

describe LinkedBus::TopicExchange do 

  it 'initialize without subscribers' do 
    exchange = LinkedBus::TopicExchange.new('watson')
    expect(exchange.subscribers).to be_empty
  end

  it 'defaults to topic exchange' do 
    exchange = LinkedBus::TopicExchange.new('moriarty')
    expect(exchange.type).to eql(:topic)
  end

  it 'needs a name' do 
    exchange = LinkedBus::TopicExchange.new('holmes_exchange')
    expect(exchange.name).to eql('holmes_exchange')
  end

  it 'has empty default options' do 
    exchange = LinkedBus::TopicExchange.new('name')
    expect(exchange.options).to eql({})
  end

  it 'accepts exchange options' do 
    exchange = LinkedBus::TopicExchange.new('watson', {durable: true})
    expect(exchange.options).to eql({durable: true})
  end

  it 'register subscribers' do
    subscriber = double('subscriber')
    exchange = LinkedBus::TopicExchange.new('holmes')
    exchange.subscribe(subscriber)
    expect(exchange.subscribers).to eql([subscriber])
  end

end