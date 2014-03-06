require 'ostruct'
require 'yaml'
require 'pry'

class LinkedBus::Configuration

  class YAMLLoader
    
    def self.run(path)
      normalize YAML.load_file(path)
    end

    private
    def self.normalize(config)
      exchange_cfg = exchange_normalize(config['exchange'] || {} )
      config.delete 'exchange'
      config.merge! exchange_cfg
    end


    def self.exchange_normalize(config)
      exchange = {}
      exchange['exchange_name'] = config['name']
      
      options = config['options'] || []
      exchange['exchange_options'] = options.reduce({}) do |acc, item|
        acc[item] = true
        acc
      end

      exchange
    end

  end

  attr_accessor :host, :port, :user, :pass, :vhost, :ssl, :heartbeat,
                :frame_max, :logfile, :env, :web_host, :web_port, 
                :exchange_name, :exchange_options, :required, :webmodule, :pidfile, :auto_test_queue,
                :ws_port, :web_user, :web_pass

  def initialize
    update!(defaults_cfg)
  end

  def update!(options)
    setup(options)
  end

  def load_file(path, loader = YAMLLoader)
    update!(loader.run(path))
  end

  def web
    cfg = {
      :user => web_user,
      :pass => web_pass,
      :host => web_host,
      :port => web_port,
      :env =>  env,
      :webmodule => webmodule,
      :ws_port => ws_port
    }

    OpenStruct.new(cfg)
  end

  def broker

    cfg = {
      :host      => host,
      :port      => port,
      :user      => user,
      :pass      => pass,
      :vhost     => vhost,
      :ssl       => ssl,
      :heartbeat => heartbeat,
      :frame_max => frame_max,
      :exchange_name  =>   exchange_name,
      :exchange_options => exchange_options
    }

    OpenStruct.new(cfg)
  end

  private

  def defaults_cfg
    {
      :host      => "localhost",
      :port      => 5672,
      :user      => "guest",
      :pass      => "guest",
      :vhost     => "/",
      :ssl       => false,
      :heartbeat => 10,
      :frame_max => 131072,
      :logfile   => STDOUT,
      :env       => "production",
      :web_host   => "0.0.0.0",
      :web_port   => 8080,
      :exchange_name  => "linkedbus",
      :exchange_options  => {},
      :required   => [],
      :webmodule => false,
      :pidfile   => './tmp/linkedbus.pid',
      :auto_test_queue => 'linkedbus.auto.test',
      :ws_port   => 8081,
      :web_user => 'admin',
      :web_pass => 'secret' 
    }
  end

  def setup(options)
    options.each do |key, value|
      self.send("#{key}=", value)
    end
  end

end
