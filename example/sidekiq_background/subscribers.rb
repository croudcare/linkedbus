require 'sidekiq'
require 'linked_bus'

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'mynamespace', :size => 1 }
end

class Publisher

  def self.call(message)
    Sidekiq::Client.push('queue' => 'WhateverQueue', 'class' => 'WorkerHandler', 'args' => [ message ])
  end

end


LinkedBus::Exchanges.register do |exchange|
  
  exchange.topic('sidekiq_exchange', { :auto_delete => true }) do |topic|
    topic.subscribe "holmes", "sidekiq_queue",  Publisher,  { durable:  true }
  end

end