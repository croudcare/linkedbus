require 'spec_helper'

require 'linked_bus'

describe LinkedBus do 

  let(:config) { double('config') }

  describe '.boot' do 

    it 'calls all components in a specific order' do

      subject.should_receive(:log!).with(config) do
        subject.should_receive(:loader!).with(config) do 
          subject.should_receive(:write_pid!).with(config) do 
            subject.should_receive(:launcher!).with(config)
          end
        end
      end
      
      LinkedBus.boot!(config)
    end

  end

  describe 'config' do

    it 'returns LinkedBus::Configuration isntance' do 
      expect(LinkedBus.config).to be_a(LinkedBus::Configuration)
    end

    it 'returns the same configuration instance' do 
      expect(LinkedBus.config).to eq(LinkedBus.config)
    end
  end
  

end
