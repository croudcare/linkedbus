LinkedBus::Subscribers.register do |manager|
  manager.subscribe "blog.signin",  "signin_queue", Subscribers::CommentHandler 
end