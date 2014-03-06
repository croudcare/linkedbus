class ThiagoHandler
  def self.call(message)
    puts "Thiago Received Message: #{message.payload}"
  end
end

class PedroHandler
  def call(message)
    puts "Pedro Received Message: #{message.payload}"
  end
end

catchAll = proc {|message| puts "Catch All Received: #{message.payload}"}


LinkedBus::Exchanges.register do |exchange|

  exchange.topic('sherlock_exchange', { :durable => true }) do |topic|

    topic.subscribe "thiago.key", "thiago_queue",  ThiagoHandler,  { durable:  true }
    topic.subscribe "pedro.key",  "pedro_queue",   PedroHandler,   { exclusive:  true }
    topic.subscribe "holmes.key", "holmes_queue",  proc { |message| puts message.payload }  , {exclusive:  true, auto_delete: true}
    topic.subscribe "#",        "all",  catchAll , { exclusive:  true, auto_delete: true }

  end

end
 