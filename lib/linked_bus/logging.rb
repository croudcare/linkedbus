require 'logger'

module LinkedBus

  class LinkLogBeauty < Logger::Formatter

    def call(severity, time, app, message)
      "[LinkedBus] #{Time.now.utc} #{Process.pid} #{severity}: #{message}\n"
    end

  end

  class Logging

    def self.setup!(config = LinkedBus.config)
      @__instance__ = new(config)
    end

    def self.__instance__(config = LinkedBus.config)
      @__instance__ ||= new(config)
    end

    def initialize(configuration)
      @logfile = configuration.logfile
      @logger = setup
    end

    def self.info(message) 
      __instance__.info message
    end

    def self.fatal(message)
      __instance__.fatal(msg)
    end

    def self.error(message)
      __instance__.info(message)
    end

    def info(message)
      @logger.info(message)  
    end

    def fatal(message)
      @logger.fatal(message)
    end
    
    def error(message)
      @logger.info(message)
    end

    private

    def setup
      logger = Logger.new(@logfile)
      logger.level = Logger::INFO
      logger.formatter = LinkLogBeauty.new
      logger
    end

  end
end
