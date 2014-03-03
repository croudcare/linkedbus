require 'ostruct'
require 'yaml'

class LinkedBus::Configuration

  attr_accessor :host, :port, :user, :pass, :vhost, :ssl, :heartbeat,
                :frame_max, :logfile, :env, :web_host, :web_port, 
                :exchange, :required, :webmodule, :pidfile, :auto_test_queue,
                :ws_port, :web_user, :web_pass

  def initialize
    update!(defaults_cfg)
  end

  def update!(options)
    setup(options)
  end

  def load_file(path)
    update!(YAML.load_file(path))
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
      :exchange  => exchange
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
      :exchange  => "linkedbus",
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
