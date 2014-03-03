require 'spec_helper'
require 'linked_bus/managers/connection_manager'

describe LinkedBus::ConnectionManager do

  describe '.connect' do

    let(:stubbed_connection){  double('connection').as_null_object }

    it "calls callback connection" do
      actual = nil 
      AMQP.should_receive(:connect).and_yield(stubbed_connection)
      cm = LinkedBus::ConnectionManager.new
      cm.connect { |conn| actual = conn }
      expect(actual).to eql(stubbed_connection)
    end

    it "connects with arguments" do 
      args = {durable: true}
      AMQP.should_receive(:connect).with(args).and_yield(stubbed_connection)
      cm = LinkedBus::ConnectionManager.new
      cm.connect(args) {}
    end

    context ".disconnect" do 
      
      before(:each) do 
        @cm = LinkedBus::ConnectionManager.new
      end

      it "without connection" do
        actual = false
        @cm.disconnect do 
          actual = true
        end 
        expect(actual).to eql(true)
      end

      it "with connection" do
        AMQP.should_receive(:connect).and_yield(stubbed_connection)
        stubbed_connection.should_receive(:disconnect).and_yield
        actual = false
        @cm.connect {}
        @cm.disconnect {
          actual = true
        }
        expect(actual).to eql(true)
      end
      
    end

    context "on error" do

      let(:block) { proc { } }

      it "registers default error callbacks" do
        AMQP.should_receive(:connect).and_yield(stubbed_connection)
        stubbed_connection.should_receive(:on_tcp_connection_failure)
        stubbed_connection.should_receive(:on_tcp_connection_loss)
        stubbed_connection.should_receive(:on_error)

        cm =LinkedBus::ConnectionManager.new
        cm.connect { }
      end

      { :on_tcp_connection_failure => :on_failure_callback, :on_error => :on_error_callback, :on_tcp_connection_loss => :on_loss_callback }.each do |key, value|
        
        it "register custom error callbacks [ #{value} ]" do 
          AMQP.should_receive(:connect).and_yield(stubbed_connection)
          stubbed_connection.should_receive(key).and_yield
          actual = false
          callable_callback = proc { actual = true }
          cm =LinkedBus::ConnectionManager.new
          cm.send("#{value}=", callable_callback) 
          cm.connect { }
          expect(actual).to be(true)
        end
      end

    end

  end
end