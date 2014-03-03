class LinkedBus::Loader

  attr_reader :options

  def initialize(options)
    @options = options
  end

  def load!
    options.required.each { |file| load file }
  end

  private

  def load(file)
    with_relative "."  do 
      load_rails_app(file) || Kernel.load(file)
    end
  end

  def rails?(file)
    rails_path = File.expand_path File.join(file, 'config/environment.rb')
    File.exists?(rails_path)
  end

  def load_rails_app(path)
    return false unless rails?(path)
    ENV['RACK_ENV'] ||= options.env
    $: << path
    require File.expand_path(File.join(path, 'config/environment.rb'))
    ::Rails.application.eager_load!
    return true
  end

  def with_relative(folder)
    $:<< folder
    yield
    $:.pop
  end

end
