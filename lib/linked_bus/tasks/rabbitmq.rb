require 'rspec'

module RabbitMQ
  module ControlPanel

    def alive?
      !! pid
    end
    
    def pid
      group_capture = /\{pid,(\d+)\}/.match(`rabbitmqctl status 2> /dev/null`)
      group_capture[1].to_i if group_capture
    end

    def start(delay = 1)
      return unless pid.nil? # already started
      puts "Starting RabbitMQ"
      `/usr/local/sbin/rabbitmq-server > /dev/null 2>&1 &`
      sleep(delay)
      stop_world_message if pid.nil?
    end

    def stop(pid = self.pid, delay = 1)
      `rabbitmqctl stop > /dev/null 2>&1`; sleep(delay)
       puts "Stopped RabbitMQ"
    end

    def stop_world_message
      puts "\n\n\nWait a minute, we did not find your rabbitmq-server binary. Is it in tour path ?\n\n\n"
      exit(-1)
    end
    private :stop_world_message

    extend self
   
  end
end

namespace :linkedbus do 
  desc "Launch RabbitMQ locally and call rspec"
  task :spec do
    RabbitMQ::ControlPanel.start(3)
    Rake::Task[:spec].invoke
    RabbitMQ::ControlPanel.stop
  end
end