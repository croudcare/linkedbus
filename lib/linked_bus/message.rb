class LinkedBus::Message

  class Metadata
    METADATA_MESSAGES = [
      :routing_key,
      :content_type,
      :priority,
      :headers,
      :timestamp,
      :type,
      :delivery_tag,
      :redelivered?,
      :exchange
    ]

    def initialize(data)
      @metadata = data
    end

    def method_missing(method, *arguments, &block)
      return super unless METADATA_MESSAGES.include?(method)
      @metadata.send(method, *arguments, &block)
    end

    def respond_to?(method_name, include_private = false)
      METADATA_MESSAGES.include?(method_name) || super
    end

    def to_s
      metadata_to_s = []
      METADATA_MESSAGES.each do |method|
        metadata_to_s.push "#{method.to_s}: [ #{self.send(method)} ]"
      end
      metadata_to_s.join(" ")
    end

  end

  attr_accessor :payload

  def initialize(payload, metadata)
    @payload = payload
    @metadata = Metadata.new(metadata)
  end
  
  def method_missing(method, *arguments, &block)
    return super unless @metadata.respond_to?(method.to_sym)
    @metadata.send(method.to_sym, *arguments, &block)
  end

  def to_s
    "Payload: [ #{@payload}  ] Metadata: #{@metadata}"
  end

end

