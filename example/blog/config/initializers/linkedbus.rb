LinkedBus::Exchanges.register do |exchange|

  exchange.topic('blog_exchange') do |topic|
    topic.subscribe "blog.signin",  "signin_queue", Subscribers::CommentHandler 
  end

end