# LinkedBus (WIP)

Authors [Thiago Dantas](https://github.com/tdantas) && [Pedro Cunha](https://github.com/pedrocunha) 

#### Web Interface  

![Web UI](https://github.com/pedrocunha/linked_bus/raw/master/docs/images/queues.jpg)    

#### Queue Details 

![Queue Detail](https://github.com/pedrocunha/linked_bus/raw/master/docs/images/queue_detail.jpg)  

#### Publish Message

![Publishing Message](https://github.com/pedrocunha/linked_bus/raw/master/docs/images/publishing.jpg)  

#### Auto Testing

![Send and Receive](https://github.com/pedrocunha/linked_bus/raw/master/docs/images/autotest.jpg)


## Installation

Add this line to your application's Gemfile:

    gem 'linked_bus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install linked_bus

## Usage

    bundle exec linkedbus -r example/subscribers.rb -C example/linkedbus_config.yml --web

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
