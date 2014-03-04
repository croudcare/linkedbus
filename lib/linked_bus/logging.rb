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

    def self.method_missing(method, *args, &block)
       return __instance__.send(method, *args, &block) if self.respond_to?(method)
       super
    end

    def self.respond_to?(method)
      return true if [:info, :fatal, :error, :warn, :debug, :level=, :level, :unknown, :add].include?(method)
      super
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
