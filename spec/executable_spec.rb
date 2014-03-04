require 'spec_helper'

require 'linked_bus/executable'

describe LinkedBus::Executable do 

  let(:configuration) { double('configuration').as_null_object }

  subject(:executable) { LinkedBus::Executable.new(configuration) }

  context 'cli options' do

    it 'required file' do
      configuration.should_receive(:update!).with({required: ['file_executable.rb']}) 
      executable.parse!(['linkedbus', '-r', 'file_executable.rb'])
    end

    it 'enviroment' do
      configuration.should_receive(:update!).with({env: 'xxx'}) 
      executable.parse!(['linkedbus', '-e', 'xxx'])
    end

    it 'logfile file' do
      configuration.should_receive(:update!).with({logfile: 'file_to_log'}) 
      executable.parse!(['linkedbus', '-l', 'file_to_log'])
    end

    it 'enable web' do 
      configuration.should_receive(:update!).with({webmodule: true}) 
      executable.parse!(['linkedbus', '--web', true])
    end

 end

  context 'load yaml file' do
    
    let(:file) { File.expand_path(File.join(File.dirname(__FILE__), './fixtures/linkedbus.yml')) }

    it 'changes linkedbus configuration based on yaml file' do
      configuration.should_receive(:load_file)
      executable.parse!([ 'linkedbus', '-C', file])
    end

    it 'override yaml with cli options' do
      configuration.should_receive(:load_file) do 
        configuration.should_receive(:update!).with({logfile: 'file_to_log'}) 
      end
      executable.parse!(['linkedbus', '-l', 'file_to_log', '-C', file])
    end

  end



  it 'boot linkedbus' do
    LinkedBus.should_receive(:boot!)
    executable.run!
  end

end