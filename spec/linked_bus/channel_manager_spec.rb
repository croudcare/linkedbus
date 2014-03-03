require 'spec_helper'
require 'linked_bus/managers/channel_manager'

describe LinkedBus::ChannelManager do

  let(:connection) { double }
  let(:channel) { double.as_null_object }

  it "creates a channel and call callback with channel" do
    @cm = LinkedBus::ChannelManager.new(connection)
    ::AMQP::Channel.should_receive(:new).with(connection).and_return(channel)
    
    actual = false
    @cm.channel { |channel| actual = channel }
    expect(actual).to eql(channel)
  end

  it "sets auto recovery to channel" do 
    cm = LinkedBus::ChannelManager.new(connection)
    ::AMQP::Channel.should_receive(:new).with(connection).and_return(channel)
    channel.should_receive(:auto_recovery=).with(true)
    cm.channel { }
  end

  context "on error" do

    let(:block) { proc { } }

    { :on_connection_interruption => :on_interruption_callback, :on_error => :on_error_callback }.each do |key, value|
        
      it "with default callbacks [ #{value} ]" do
        ::AMQP::Channel.should_receive(:new).with(connection).and_return(channel)
        channel.should_receive(key)
        cm = LinkedBus::ChannelManager.new(connection)
        cm.channel { |channel|  }
      end

      it "with custom callbacks [#{value}]" do 
        actual = false
        block = proc { |*args| actual = true }
        ::AMQP::Channel.should_receive(:new).with(connection).and_return(channel)
        channel.should_receive(key).and_yield
        cm = LinkedBus::ChannelManager.new(connection)
        cm.send("#{value}=", block)
        cm.channel { |channel|  }
        expect(actual).to eql(true)
      end

    end

  end

end