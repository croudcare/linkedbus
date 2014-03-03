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

class ExceptionHandler
  def self.call(message)
    raise "Failure"
  end
end

LinkedBus::Subscribers.register do |manager|
  manager.subscribe "authors.thiago.dantas",  "thiago_dantas_queue",  ThiagoHandler
  manager.subscribe "authors.pedro.cunha",    "pedro_cunha_queue",    PedroHandler.new
  manager.subscribe "authors.*",              "catch_all_queue",      catchAll
  manager.subscribe "exception",              "exception_queue",      ExceptionHandler
  manager.subscribe %w[brazil portugal],      "country_queue",        proc {|message| puts "Country Queue received: #{message.payload}"}
end