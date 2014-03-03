require 'spec_helper'

require 'linked_bus/pid'

describe LinkedBus::Pid do 
  
  let(:path) { './tmp/linkedbus.pid' }

  after(:each) do 
    FileUtils.rm_rf(Pathname.new(path).dirname)
  end

  it "Write the pid in the specified file" do
    LinkedBus::Pid.write(path)
    expect(File.read(path)).to match(/#{Process.pid}/)
  end

end