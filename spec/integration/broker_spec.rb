require 'spec_helper'

describe "Broker Integration" do
  include EventedSpec::SpecHelper

  default_timeout 5

  before(:all) do

    LinkedBus.config.tap do |cfg|
      cfg.host  = "localhost"
      cfg.port  = 5672
      cfg.user  = "guest"
      cfg.pass  = "guest"
      cfg.vhost = "/"
      cfg.exchange = "broker_integration_test"
    end
    LinkedBus::Spec.disable_handler_exception!
    LinkedBus::Spec.disable_log!
    @publisher = LinkedBus::Spec.publisher(LinkedBus.config)
  end

  before(:each) do
    LinkedBus::Subscribers.clear!
  end
  
  it "subscriber receives the same published message" do

    em do 
      handler = proc {|message|  expect(message.payload).to eql("Hello World"); done }

      LinkedBus::Subscribers.register do |manager|
        manager.subscribe "key.handler",  AMQ::Protocol::EMPTY_STRING,  handler
      end

      LinkedBus.reconnect! {
        EM.add_timer(0.5){
          @publisher.publish("key.handler", "Hello World")
        }
      }
    end
  end

  it "accepts multiple subscribers on different queues" do 
    results = []
    em do
      first_handler  = proc {|message| expect(message.payload).to eql("first");  results << true }
      second_handler = proc {|message| expect(message.payload).to eql("second"); results << true }

      LinkedBus::Subscribers.register do |manager|
        manager.subscribe "key.first",  AMQ::Protocol::EMPTY_STRING,  first_handler
        manager.subscribe "key.second", AMQ::Protocol::EMPTY_STRING, second_handler
      end
     
      LinkedBus.reconnect! {
        EM.add_timer(0.3) {
          @publisher.publish("key.first", "first") 
          @publisher.publish("key.second", "second")
          done(1)
        }
      }
    end
    expect(results.length).to eql(2)
  end


  it "accepts distinct keys on same queue" do
    results = []
    em do
      handler  = proc {|message| results << 10 }

      LinkedBus::Subscribers.register do |manager|
        manager.subscribe ["key.shared", "key.same"], AMQ::Protocol::EMPTY_STRING, handler
      end
     
      LinkedBus.reconnect! {
        EM.add_timer(0.5) {
          @publisher.publish("key.shared", "shared") 
          @publisher.publish("key.same",   "shared") 
          done(1)
        }
      }

    end

    total = results.reduce(0){ |acc, item| acc + item }
    expect(total).to eql(20)
  end

  it "accepts two subscribers on same queue" do
    result = []
    queue_name = "queue_name_#{Time.now.to_i}"
    em do 
      LinkedBus::Subscribers.register do |manager|
        manager.subscribe "round",  queue_name,  proc {|message| result.push("first")}
        manager.subscribe "round",  queue_name,  proc{| message| result.push("second")}
      end
      
      LinkedBus.reconnect! {
        EM.add_timer(0.5) {
          @publisher.publish("round", "message") 
          @publisher.publish("round", "message") 
          done(1)
        }
      }
    end
    expect(result).to include("first")
    expect(result).to include("second")

  end
  
end