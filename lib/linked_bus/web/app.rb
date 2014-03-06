require 'thin'
require 'sinatra/base'
require 'fiber'
require 'rack/fiber_pool'

require 'linked_bus/web/services/rabbitmq'
require 'linked_bus/web/services/testify'
require 'securerandom'

module LinkedBus

 class WebApp < Sinatra::Base
    use Rack::FiberPool

    set :raise_errors, lambda { false }
    set :show_exceptions, false

    use Rack::Session::Cookie,  :secret => 'This one time, at band camp...'

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      [username, password] == [LinkedBus.config.web_user, LinkedBus.config.web_pass]  
    end

    before '/*' do
      session[:identity] ||= SecureRandom.hex(10)
      @identity = session[:identity]
    end
    
    get '/' do
      all_queues = Service::RabbitMQ.queues
      all_queues.reject! { |queues| queues.name == Service::Testify.queue_name }
      @queues = all_queues
      erb :home
    end

    get '/api/alive' do 
      if Service::RabbitMQ.alive?
        status 200
      else
        status 422
      end
    end

    get '/api/queues/:name' do
      content_type :json
      @queue = Service::RabbitMQ.queue_info(params[:name])
      @queue.to_json
    end

    get '/publish/:queue_name/new' do 
      @queue_name = params[:queue_name]
      @bindings = Service::RabbitMQ.bindings(params[:queue_name])
      erb :publish_form, :layout => false
    end

    post '/publish/:queue_name' do
      if Service::RabbitMQ.publish(params[:keys], params[:message])
        status 200
      else
        status 422
      end
    end

    get '/queues/:name' do 
      @queue = Service::RabbitMQ.queue_info(params[:name])
      erb :queue, :layout => false
    end

    post '/test/me' do
      Service::Testify.publish(@identity)
      status 201
    end

  end
end