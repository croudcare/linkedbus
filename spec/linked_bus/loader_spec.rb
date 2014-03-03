require 'spec_helper'

require 'linked_bus/loader'

describe LinkedBus::Loader do

  def find_full_path(path)
    File.expand_path(File.join(File.dirname(__FILE__), path))
  end

  def remove_const(const)
    Object.send(:remove_const, const) if defined? const
  end

  let(:config) { double('loader', :required => files) }
  let(:load!)  { LinkedBus::Loader.new(config).load! }

  context 'when single file' do 
    let(:files) {[
      find_full_path('../fixtures/holmes_fixture.rb') 
    ]}

    it 'requires holmes fixture' do 
      expect { load! }.to change{ !! defined? HolmesFixture }.from(false).to(true)
    end

    after do
      remove_const :HolmesFixture
    end

  end

  context 'when multiple files' do

    let(:files) {[
      find_full_path('../fixtures/watson_fixture.rb'),
      find_full_path('../fixtures/holmes_fixture.rb')
    ]}
    
    it 'requires holmes fixture' do
      expect { load! }.to change{ !! defined? HolmesFixture }.from(false).to(true)
    end

    it 'requires watson fixture' do
      expect { load! }.to change{ !! defined? WatsonFixture }.from(false).to(true)
    end

    after do
      remove_const :HolmesFixture
      remove_const :WatsonFixture
    end

  end

  context 'when dir' do

    xit 'requires a rails app' do
    end

  end
end
