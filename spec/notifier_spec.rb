require 'spec_helper'

require 'linked_bus/notifier'

describe LinkedBus::Notifier do

  let(:delay) { 0 }
  subject { LinkedBus::Notifier.new(delay) }

  it 'sends buffered message after delay' do
    actual = []
    EM.run do  
      subject.handler = proc { |buffer| actual.concat(buffer); EM.stop}
      subject.register 'first delay'
      subject.register 'second delay'
    end
    expect(actual).to eql(['first delay', 'second delay'])
  end

  it 'clear buffer' do 
    EM.run do  
      subject.handler = proc { |buffer|  EM.stop } 
      subject.register 'clear after delay'
    end
    expect(subject.buffer).to eql([])
  end

  it 'responds register' do
    expect(subject.respond_to?(:register)).to eql(true) 
  end



end