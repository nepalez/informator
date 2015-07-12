Informator
==========

[![Gem Version](https://img.shields.io/gem/v/informator.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/informator/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/informator.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/informator.svg?style=flat)][codeclimate]
[![Coverage](https://img.shields.io/coveralls/nepalez/informator.svg?style=flat)][coveralls]
[![Inline docs](http://inch-ci.org/github/nepalez/informator.svg)][inch]

[codeclimate]: https://codeclimate.com/github/nepalez/informator
[coveralls]: https://coveralls.io/r/nepalez/informator
[gem]: https://rubygems.org/gems/informator
[gemnasium]: https://gemnasium.com/nepalez/informator
[travis]: https://travis-ci.org/nepalez/informator
[inch]: https://inch-ci.org/github/nepalez/informator

The [wisper]-inspired tiny implementation of publish/subscribe design pattern.

The implementation differs from the original wisper's approach in the following aspects:

* Unlike `Wisper::Publisher` that calls listener methods depending on the event, the `Informator` uses the same listener's callback for sending all events. Instead it wraps attributes to `Informator::Event` container and uses its as the argument for the callback.

* The `Informator` has two separate methods - `#remember` and `#publish`. The first one is used to build and collect events, while the second one publishes all unpublished events at once (and clears the list of events to be published).

* The `Informator` also defines `#publish!` method that is the same as `#publish` except for it throws the `:published`, that should be catched somewhere. This is just a shortcut for exiting from a use cases.

* The `#publish` method returns the list of published events. The exception thrown by `#publish!` carries that list as well. This allows not only to publish them to listeners but to return them to caller. This is necessary to simplify chaining of service objects that includes the `Informator`.

* The `Informator` has no global neither async subscribers. The gem's scope is narrower. Its main goal is to support service objects, that are either chained to each other, or publishes their results to decoupled listeners.

[wisper]: https://github.com/krisleech/wisper

Synopsis
--------

The `Informator` module API defines 4 instance methods:

* `#subscribe` to subscribe listeners for receiving events, published by the informator
* `#remember` to build an event and keep it unpublished
* `#publish` to publish all events keeped since last publishing
* `#publish!` the same as `#publish`, except for it throws `:published` exception which carries a list of events

Except for the `Informator` the module defines public class `Informator::Event` for immutable events, that has 3 attributes:

* `#type` for symbolic type of the event
* `#attributes` for hash of attributes, carried by the event
* `#messages` for array of human-readable messages, describing the event

The event instance is build by the `#remember`, `#publish` or `#publish!` methods and is sent to listeners by either `#publish` or `#publish!`. When sending an event, the informator just calls the listeners callback, defined by `#subscribe` method, and gives it a corresponding event object as the only argument.

```ruby
require "informator"

class Listener
  def receive(event)
    puts "The listener received #{ event.type }: #{ event.messages }"
  end
end

listener = Listener.new

class Service
  include Informator

  def call
    catch(:published) { do_some_staff }
  end

  def do_some_staff
    # ...
    remember :success, "for now all is fine", foo: :bar
    #
    publish! :error, "OMG!", bar: :baz
  end
end

service = Service.new
service.subscribe listener, :receive
result = service.call
# The listener received success: ["for now all is fine"]
# The listener received error: ["OMG!"]
# => [
#      #<Informator::Event @type=:success @attributes={ foo: :bar } @messages=["for now all is fine"]>,
#      #<Informator::Event @type=:error @attributes={ bar: :baz } @messages=["OMG!"]>
#    ]

```

In the example above the `listener#receive` method is called twice with the first, and then with the second event as an argument.

Then the `publish!` throws an exception that carries the list of messages.
The `service#call` catches it and returns the array of events. With this feature it is possible not only to subscribe for the service's events but receive it directly, combining [both telling and asking](http://martinfowler.com/bliki/TellDontAsk.html) when necessary.

Installation
------------

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem "informator"
```

Then execute:

```
bundle
```

Or add it manually:

```
gem install informator
```

Compatibility
-------------

Tested under rubies [compatible to MRI 2.1+](.travis.yml).

Uses [RSpec] 3.0+ for testing and [hexx-suit] for dev/test tools collection.

[RSpec]: http://rspec.org
[hexx-suit]: https://github.com/nepalez/hexx-suit

Contributing
------------

* Read the [STYLEGUIDE](config/metrics/STYLEGUIDE)
* [Fork the project](https://github.com/nepalez/informator)
* Create your feature branch (`git checkout -b my-new-feature`)
* Add tests for it
* Commit your changes (`git commit -am '[UPDATE] Add some feature'`)
* Push to the branch (`git push origin my-new-feature`)
* Create a new Pull Request

License
-------

See the [MIT LICENSE](LICENSE).
