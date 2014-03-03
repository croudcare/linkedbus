class LinkedBus::Subscriber

  attr_accessor :key, :queue_name, :handler, :options

  def initialize(keys, queue_name, handler, options ={})
    @key        = keys
    @queue_name = queue_name
    @handler    = handler
    @options    = options
  end

  def to_s
    "Subscriber -> key: [#{key}] queue_name: [#{queue_name}] handler: [#{handler}]"
  end

end

