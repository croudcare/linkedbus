# encoding: UTF-8

module LinkedBus::Welcome

  SM_QUOTES= [
    "My name is Sherlock Holmes.  It is my business to know what other people don't know.",
    "You know my methods, Watson.",
    "The name is Sherlock Holmes and the address is 221B Baker Street.",
    "The lowest and vilest alleys in London do not present...",
    "London, that great cesspool into which all the loungers...",
    "To Sherlock Holmes she is always the woman.",
    "It is the unofficial force—the Baker Street irregulars.",
    "The fair sex is your department.",
    "...the curious incident of the dog in the night-time...",
    "They were the footprints of a gigantic hound!",
    'There is nothing like first-hand evidence.',
    'You see, but you do not observe. The distinction is clear.',
    'I never guess. It is a shocking habit,—destructive to the logical faculty.'
  ]

  def self.greeting
    ["[Sherlock Holmes ]", SM_QUOTES.sample].join(" ")
  end

end
