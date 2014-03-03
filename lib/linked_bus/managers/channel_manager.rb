require 'delegate'
require 'linked_bus/logging'
require 'amqp'

class LinkedBus::ChannelManager
  
  attr_accessor :on_interruption_callback, :on_error_callback
  def initialize(connection)
    @connection = connection
   
    @on_interruption_callback =  proc do |ch| 
      LinkedBus::Logging.info "Channel #{ch.id} detected connection interruption"
    end
    
    @on_error_callback = proc do |channel, channel_close| 
      LinkedBus::Logging.info "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
    end
  end

  def channel(&block)
    ch = setup_channel!
    register_errors!(ch)
    block.call ch 
 end

  private

  def setup_channel!
    @channel ||= ::AMQP::Channel.new(@connection).tap do |ch|
      ch.auto_recovery = true
    end
  end

  def register_errors!(ch)
    on_error(ch)
    on_interruption(ch)
  end

  def on_error(ch)
    ch.on_error &@on_error_callback
  end

  def on_interruption(ch)
    ch.on_connection_interruption &@on_interruption_callback
  end

end
