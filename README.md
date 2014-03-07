# LinkedBus (WIP)
[![Code Climate](https://codeclimate.com/repos/5314e4d1e30ba06d7c000d10/badges/f8d7dcfc5d8fe705a19d/gpa.png)](https://codeclimate.com/repos/5314e4d1e30ba06d7c000d10/feed)
[![Build Status](https://travis-ci.org/tdantas/linkedbus.png?branch=master)](https://travis-ci.org/tdantas/linkedbus)

Authors [Thiago Dantas](https://github.com/tdantas) && [Pedro Cunha](https://github.com/pedrocunha)   

We are already running this WIP in Staging and Production ( Yes ! Believe or not we are already using it. )

## Installation

#### Gemfile
	
	gem 'linked_bus', git: 'https://github.com/tdantas/linkedbus.git'
	


 We are finishing the gem and as soon as possible we publish to rubygems  
 For now, git clone is your best friend
 
## Usage

Let's suppose that your application has many services and one event will trigger multiple actions in different services.

To achieve that, we built linkedbus.  
The ideia is pretty simple:

We subscribe RabbitMQ and wait for messages.

### Let's start 

**Clone the repository**
	
	git clone git@github.com:tdantas/linkedbus.git
	cd linkedbus/

**Download the dependencies**

	bundle install

**Start your rabbitmq**

	rabbitmq-server

**Subscribing the RabbitMQ**
	
	bundle exec linkedbus -r example/subscribers.rb  --web
	
    What -r and --web means ?
     -r will load the file inside linkedubs, so every class and module will be available.
     --web is a switch option. It means enable web interface	

How to verify ?
 
 - Using RabbitMQ Management Plugin
 
 - Using LinkedBus Web Interface  
     **http://localhost:8080**  
 	 **user: admin**  
 	 **pass: secret**
 	
 - Programatically publishing message to rabbitMQ ( use [Bunny](https://github.com/ruby-amqp/bunny) ). Publish to linkedbus exchange with key defined in **example/subscribers.rb**
    

### How to load my rails domain inside linkedbus ?
Go to [Rails Blog](https://github.com/tdantas/linkedbus/tree/master/example/blog) example and order (yes master) linkedbus to load current folder.

	cd example/blog
	bundle install
	bundle exec linkedbus -r . --web

Watch out, linkedbus run inside eventmachine, slow operations will block the reactor and new incoming messages will have to wait slow operation to finish.

**Happy Hacking !**



## TODO

  - SSL Support: Broker and Web Module
  - Better Confidence Tests
  - Logging to Syslog
  - Enabling Environment Variables Configuration 
  
#### Want to understand the code ?

What happen when I call linkedbus binary ?

````
 $ bundle exec linkedbus -C linkedbus.yml -r subscribers.rb --web
 
   bin/linkedbus
   +
   +-+ LinkedBus::Executable ( setup the configuration from cli , yaml and defaults )
       +
       +- LinkedBus.boot!
          +
          +- LinkedBus::Logging  ( configure the logging)
          +- LinkedBus::Loader   ( load the dependencies - subscribers.rb for instance )
          +- LinkedBus::Pid      ( setup the pid properly )
          +- LinkedBus::Launcher ( launch the broker and webmodule )
             +
             +- LinkedBus::WebModule ( Web application module )
             +- LinkedBus::Broker    ( Communicate with rabbitMQ )
               +
               +- LinkedBus::ConnectionManager ( setup the connection )
               +- LinkedBus::ChannelManager    ( create a channel with rabbitmq )
                  +
                  +- LinkedBus::Consumer       ( subscribe to rabbitmq )   
  ````




## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
