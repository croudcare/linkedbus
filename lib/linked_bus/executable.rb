require 'optparse'
require 'linked_bus'

module LinkedBus

  class Executable
    
    def initialize(config = LinkedBus.config)
      @config       = config
      @cli_options  = { }
    end

    def parse!(params=ARGV)
      parser = OptionParser.new do |o|

        o.banner = "linkedbus [options]"

        o.on("-r", "--require FILE", "Require the FILE before executing your script") do |file|
         @cli_options[:required] = [ file ]
        end

        o.on '-e', '--environment ENV', "Application environment" do |arg|
          @cli_options[:env] = arg
        end

        o.on '-l', '--logfile PATH', "path to log file" do |arg|
          @cli_options[:logfile] = arg
        end

        o.on '-C', '--config PATH', "path to config file" do |file|
          @cli_options[:config_file] = file
        end

        o.on '-w', '--web', "Enable web module" do
          @cli_options[:webmodule] = true
        end

        o.on '-V', '--version', "Print version and exit" do |arg|
          puts "LinkedBus #{LinkedBus::VERSION}"
          exit(0)
        end

        o.on_tail("-h", "--help", "Show this message") do
          puts o
          exit(0)
        end
      end
      
      parser.parse!(params)
      setup_configuration
    end

    def run!
      LinkedBus.boot!(@config)
    end

    private
      # CLI > YAML FILE > DEFAULTS
      def setup_configuration
        @config.tap do |cfg|
          cfg.load_file(@cli_options[:config_file]) if @cli_options[:config_file]
          @cli_options.delete :config_file
          cfg.update!(@cli_options)
        end
      end

  end
end