class LinkedBus::Exchange
  
  attr_reader :type, :options, :subscribers, :name
  def initialize(name, type = :topic, options = {})
    @type = type
    @name = name
    @options = options
    @subscribers = []
  end

  def subscribe(subscriber)
    @subscribers.push subscriber
  end 

  def build_broker_exchange(channel)
    raise 'must be implemented by a concret type'
  end

end


class LinkedBus::TopicExchange < LinkedBus::Exchange
  def initialize(name, options = {})
    super(name, :topic, options)
  end

  def build(channel)
    channel.topic(name, options)
  end

end