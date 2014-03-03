require "linked_bus/version"

module LinkedBus

  def self.config
    @configuration ||= Configuration.new
  end

  def self.boot!(config = self.config)
    log!(config)
    loader!(config)
    write_pid!(config)
    launcher!(config)
  end

  def self.reconnect!(config = self.config, &block)
    block ||= proc {}
    launcher(config).reconnect!(&block)
  end

  def self.loader(config)
    @loader ||= LinkedBus::Loader.new(config)
  end

  def self.launcher(config)
    @launcher ||= LinkedBus::Launcher.new(config, web, broker)
  end

  def self.broker
    @broker ||= LinkedBus::Broker.new(config.broker)
  end

  def self.web
    @web ||= config.webmodule ? LinkedBus::WebModule.new(config) : LinkedBus::WebModule.NULL
  end

  private
  def self.log!(config)
    Logging.setup!(config)
    Logging.info Welcome.greeting
  end

  def self.loader!(config)
    loader(config).load!
  end

  def self.write_pid!(config)
    Pid.write(config.pidfile)
  end

  def self.launcher!(config)
    launcher(config).start
  end

end

require 'linked_bus/configuration'
require 'linked_bus/logging'
require 'linked_bus/welcome'
require 'linked_bus/loader'
require 'linked_bus/launcher'
require 'linked_bus/pid'

