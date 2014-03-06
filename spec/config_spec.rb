require 'spec_helper'
require 'linked_bus/configuration'


describe LinkedBus::Configuration do 
  
  describe "defaults" do 

    let(:config) { LinkedBus::Configuration.new }
    
    its(:host)             { expect(config.host).to eql('localhost')}
    its(:port)             { expect(config.port).to eql(5672)}
    its(:user)             { expect(config.user).to eql('guest')}
    its(:pass)             { expect(config.pass).to eql('guest')}
    its(:vhost)            { expect(config.vhost).to eql('/')}
    its(:exchange_name)    { expect(config.exchange_name).to eql('linkedbus')}
    its(:exchange_options) { expect(config.exchange_options).to eql({})}
    its(:ssl)              { expect(config.ssl).to eql(false)}
    its(:heartbeat)        { expect(config.heartbeat).to eql(10)}
    its(:frame_max)        { expect(config.frame_max).to eql(131072)}
    its(:logfile)          { expect(config.logfile).to eql(STDOUT)}
    its(:env)              { expect(config.env).to eql('production')}
    its(:web_host)         { expect(config.web_host).to eql('0.0.0.0')}
    its(:web_port)         { expect(config.web_port).to eql(8080)}
    its(:required)         { expect(config.required).to eql([]) }
    its(:webmodule)        { expect(config.webmodule).to eql(false)}
    its(:pidfile)          { expect(config.pidfile).to eql('./tmp/linkedbus.pid')}
    its(:auto_test_queue)  { expect(config.auto_test_queue).to eql('linkedbus.auto.test')}
    its(:ws_port)          { expect(config.ws_port).to eql(8081) }
    its(:web_user)         { expect(config.web_user).to eql('admin') }
    its(:web_pass)         { expect(config.web_pass).to eql('secret') }

  end
  
  describe 'overriding' do

    let(:config) { LinkedBus::Configuration.new  }
    
    its(:host) do
      config.host = '127.0.0.1'
      expect(config.host).to eql('127.0.0.1')
    end
    
    its(:port) do 
      config.port = 123456
      expect(config.port).to eql(123456)
    end 

    its(:user) do 
      config.user = 'holmes'
      expect(config.user).to eql('holmes')
    end 

    its(:pass) do 
      config.pass = 'holmes'
      expect(config.pass).to eql('holmes')
    end

    its(:vhost) do 
      config.vhost = 'watson'
      expect(config.vhost).to eql('watson')
    end

    its(:exchange_name) do 
      config.exchange_name = 'moriarty'
      expect(config.exchange_name).to eql('moriarty')
    end

    its(:exchange_options) do 
      config.exchange_options = {'durable' => true }
      expect(config.exchange_options).to eql({ 'durable' => true })
    end

    its(:ssl) do 
      config.ssl = true
      expect(config.ssl).to eql(true)
    end

    its(:heartbeat) do
      config.heartbeat = 100
      expect(config.heartbeat).to eql(100)
    end

    its(:frame_max) do
      config.frame_max = 666
      expect(config.frame_max).to eql(666)
    end

    its(:logfile) do
      config.logfile = './thiago'
      expect(config.logfile).to eql('./thiago')
    end

    its(:env) do
      config.env = 'production'
      expect(config.env).to eql('production')
    end

    its(:web_host) do
      config.web_host = '1.1.1.1'
      expect(config.web_host).to eql('1.1.1.1')
    end

    its(:web_port) do
      config.web_port = 8088
      expect(config.web_port).to eql(8088)
    end

    its(:required) do
      config.required << 'file'
      expect(config.required).to eql(['file'])
    end

    its(:webmodule) do
      config.webmodule = true
      expect(config.webmodule).to eql(true)
    end

    its(:pidfile) do
      config.pidfile = 'pidfile'
      expect(config.pidfile).to eql('pidfile')
    end

    its(:auto_test_queue) do
      config.auto_test_queue = 'whatever_queue'
      expect(config.auto_test_queue).to eql('whatever_queue')
    end

    its(:ws_port) do
      config.ws_port = 3214
      expect(config.ws_port).to eql(3214)
    end

    its(:web_user) do
      config.web_user = 'superadmin'
      expect(config.web_user).to eql('superadmin')
    end

    its(:web_pass) do
      config.web_pass = 'super_secret'
      expect(config.web_pass).to eql('super_secret')
    end
  end

  describe "return sub-configuration" do 
    let(:configuration ) { LinkedBus::Configuration.new }

    context "web" do 
      let(:web) { configuration.web }

      its(:web_pass) { expect(web.pass).to eql('secret') }
      its(:web_port) { expect(web.port).to eql(8080) }
      its(:web_user) { expect(web.user).to eql('admin') }
      its(:web_host) { expect(web.host).to eql('0.0.0.0') }
      its(:env)      { expect(web.env).to      eql('production') }

    end

    context "broker" do

      let(:broker) { configuration.broker }

      its(:host)          { expect(broker.host).to       eql('localhost') }
      its(:port)          { expect(broker.port).to       eql(5672) }
      its(:user)          { expect(broker.user).to       eql('guest') }
      its(:pass)          { expect(broker.pass).to       eql('guest') }
      its(:vhost)         { expect(broker.vhost).to      eql('/') }
      its(:ssl)           { expect(broker.ssl).to        eql(false) }
      its(:heartbeat)     { expect(broker.heartbeat).to  eql(10) }
      its(:frame_max)     { expect(broker.frame_max).to  eql(131072) }
      its(:exchange_name) { expect(broker.exchange_name).to   eql('linkedbus') }

    end
  end


  describe "load options from yaml file" do

    before(:all) do
      @configuration = LinkedBus::Configuration.new 
      file = File.expand_path(File.join(File.dirname(__FILE__), './fixtures/linkedbus.yml'))
      @configuration.load_file(file)
    end

    its(:host)            { expect(@configuration.host).to eql('192.168.1.1') }
    its(:port)            { expect(@configuration.port).to eql(5555) }
    its(:user)            { expect(@configuration.user).to eql('mr_holmes') }
    its(:pass)            { expect(@configuration.pass).to eql('mr_holmes_pass') }
    its(:vhost)           { expect(@configuration.vhost).to eql('/virtual_host') }
    its(:exchange_name)   { expect(@configuration.exchange_name).to eql('linked_file_bus') }
    its(:exchange_options){ expect(@configuration.exchange_options).to eql({ "durable" => true })}
    its(:ssl)             { expect(@configuration.ssl).to eql(true) }
    its(:heartbeat)       { expect(@configuration.heartbeat).to eql(100) }
    its(:frame_max)       { expect(@configuration.frame_max).to eql(130000) }
    its(:logfile)         { expect(@configuration.logfile).to eql('./logfile') }
    its(:env)             { expect(@configuration.env).to eql('environment_defined') }
    its(:web_host)        { expect(@configuration.web_host).to eql('1.1.1.1') }
    its(:web_port)        { expect(@configuration.web_port).to eql(9999) }
    its(:required)        { expect(@configuration.required).to eql(['file.rb', 'second.rb']) }
    its(:webmodule)       { expect(@configuration.webmodule).to eql(true) }
    its(:pidfile)         { expect(@configuration.pidfile).to eql('./tmp/linkedbus_file.pid') }
    its(:auto_test_queue) { expect(@configuration.auto_test_queue).to eql('linkedbus.auto.test.queue') }
    its(:ws_port)         { expect(@configuration.ws_port).to eql(8888) }
    its(:web_user)        { expect(@configuration.web_user).to eql('admin_user') }
    its(:web_pass)        { expect(@configuration.web_pass).to eql('secret_pass') }
  end



end



