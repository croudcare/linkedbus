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

    def self.warn(message)
      __instance__.warn(message)
    end

    def self.debug(message)
      __instance__.debug(message)
    end

    def self.level=(_level)
      __instance__.level = _level
    end

    def self.level
      __instance__.level
    end

    def self.unknown(message)
      __instance__.unknown(message)
    end

    def self.add(level, msg)
      __instance__.add(level, msg)
    end

    def add(level, msg)
      @logger.add(level, msg)
    end

    def unknown(message)
      @logger.unknown(message)
    end

    def info(message)
      @logger.info(message)  
    end

    def fatal(message)
      @logger.fatal(message)
    end
    
    def debug(message)
      @logger.debug(message)
    end

    def error(message)
      @logger.error(message)
    end

    def level=(_level)
      @logger.level = _level
    end

    def level
      @logger.level
    end

    private

    def setup
      logger           = Logger.new(@logfile)
      logger.level     = Logger::INFO
      logger.formatter = LinkLogBeauty.new
      logger
    end

  end
end
