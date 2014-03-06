require 'spec_helper'

require 'linked_bus/executable'

describe LinkedBus::Executable do 

  let(:configuration) { double('configuration').as_null_object }

  subject(:executable) { LinkedBus::Executable.new(configuration) }

  context 'command line interface options #parse!' do

    it 'required file' do
      configuration.should_receive(:update!).with({required: ['file_executable.rb']}) 
      executable.parse!(['linkedbus', '-r', 'file_executable.rb'])
    end

    it 'environment' do
      configuration.should_receive(:update!).with({env: 'xxx'}) 
      executable.parse!(['linkedbus', '-e', 'xxx'])
    end

    it 'logfile' do
      configuration.should_receive(:update!).with({logfile: 'file_to_log'}) 
      executable.parse!(['linkedbus', '-l', 'file_to_log'])
    end

    it 'enable web' do 
      configuration.should_receive(:update!).with({ webmodule: true }) 
      executable.parse!(['linkedbus', '--web', true])
    end

    it 'config file' do
      configuration.should_receive(:load_file).with('path/file')
      executable.parse!([ 'linkedbus', '-C', 'path/file'])
    end

    it 'override yaml with cli options' do
      configuration.should_receive(:load_file) do 
        configuration.should_receive(:update!).with({ logfile: 'file_to_log' }) 
      end
      executable.parse!(['linkedbus', '-l', 'file_to_log', '-C', 'path/file'])
    end

  end

  it 'boot linkedbus' do
    LinkedBus.should_receive(:boot!).with(configuration)
    executable.run!
  end

end