# LinkedBus (WIP)
[![Code Climate](https://codeclimate.com/repos/5314e4d1e30ba06d7c000d10/badges/f8d7dcfc5d8fe705a19d/gpa.png)](https://codeclimate.com/repos/5314e4d1e30ba06d7c000d10/feed)
[![Build Status](https://travis-ci.org/tdantas/linkedbus.png?branch=master)](https://travis-ci.org/tdantas/linkedbus)

Authors [Thiago Dantas](https://github.com/tdantas) && [Pedro Cunha](https://github.com/pedrocunha)   

We are already running this WIP in Staging and Production ( Yes ! Believe or not we are already using it. )

#### Web Interface  

![Web UI](https://github.com/tdantas/linkedbus/raw/master/docs/images/queues.jpg)    

#### Queue Details 

![Queue Detail](https://github.com/tdantas/linkedbus/raw/master/docs/images/queue_detail.jpg)  

#### Publish Message

![Publishing Message](https://github.com/tdantas/linkedbus/raw/master/docs/images/publishing.jpg)  

#### Auto Testing

![Send and Receive](https://github.com/tdantas/linkedbus/raw/master/docs/images/autotest.jpg)


## Installation

Add this line to your application's Gemfile:

    gem 'linked_bus' # not yet published at rubygems

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linked_bus

## Usage

    bundle exec linkedbus -r example/subscribers.rb -C example/linkedbus_config.yml --web

## TODO

  - SSL Support: Broker and Web Module
  - Better Confidence Tests

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
