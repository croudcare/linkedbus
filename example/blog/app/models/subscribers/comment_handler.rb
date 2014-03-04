# Every handler must be a callable with arity 1

module Subscribers
  

  class CommentHandler

    def self.call(message)
      puts "[Rails] Saving"
      puts "[Rails] #{message.payload}"
    end

  end
  
end