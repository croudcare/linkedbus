require_relative 'publisher_spec_helper'

module LinkedBus

  module Spec

    def clear_subscribers!
      LinkedBus::Exchanges.clear!
    end

    def stop!
      LinkedBus.stop!
    end

    def publisher(config)
      Publisher.new(config.user, config.pass, config.vhost)
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