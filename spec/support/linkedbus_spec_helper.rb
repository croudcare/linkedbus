require_relative 'publisher_spec_helper'

module LinkedBus

  module Spec

    def subscribe(key, queue, handler)
      LinkedBus::Subscribers.register do |manager|
        manager.subscribe key, queue, handler
      end
    end

    def clear_subscribers!
      LinkedBus::Subscribers.clear!
    end

    def stop!
      LinkedBus.stop!
    end

    def publisher(config)
      Publisher.new(config.user, config.pass, config.vhost, config.exchange)
    end

    def disable_handler_exception!
      $DISABLE_HANDLER_EXCEPTION = true
    end

    def disable_log!
      LinkedBus.config.logfile = "/dev/null"
    end

    extend self

  end
end