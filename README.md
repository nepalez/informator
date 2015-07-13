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

The [wisper]-inspired micro-gem, that implements publish/subscribe design pattern in immutable style.

**Notice a version `1.0` has been re-written from scratch to provide immutability. Its API has been changed.**

Motivation
----------

The `informator` differs from `wisper` in the following aspects:

* While `Wisper::Publisher#subscribe` mutates the state of the publisher, `Informator::Publisher` is immutable.
  Its `#subscribe` method returns the new publisher instance to which a subscriber being added.

* The `Wisper::Publisher#publish` calls various listener methods depending on the published event.
  The `Informator::Publisher#publish` uses the same listener's callback for all published events. It sends the `Invormator::Event` with info about the name, the attributes, and the publisher of the event.

* The `Informator::Publisher` defines `#publish!` method that is the same as `#publish`, except for it throws the `:published` exception.
  This can be used to stop execution when some events occurs.

* The `Informator` has no global neither async subscribers.

[wisper]: https://github.com/krisleech/wisper

API
---

The `Informator::Publisher` class describes immutable publishers with 6 instance methods:

* `#initialize` that takes a hash of attributes.
* `#attributes` that stores a hash of initialized attributes.
* `#subscribers` that returns an array of subscribers.
* `#subscribe` that returns a new immutable publisher with the same attributes and new subscriber being added.
* `#publish` to create and publish an event to all `#subscribers`.
* `#publish!` that calls `#publish` and then throws `:published` exception.

The `Informator::Event` class describes immutable events with 4 instance methods:

* `#publisher` for the source of the event.
* `#name` for symbolic name of the event.
* `#attributes` for hash of attributes, carried by the event.
* `#message` for the human-readable description of the event.

Synopsis
--------

Define the custom publisher, inherited from the `Informator::Publisher` base class:

```ruby
require "informator"

class MyPublisher < Informator::Publisher
  def call
    if attributes[:luck]
      publish :success, exclamation: "Wow"
    else
      publish :error, exclamation: "OMG"
    end
  end
end
```

Provide translations for events:

```yaml
# config/locales/en.yml
---
en:
  informator:
    my_publisher:
      success: "%{exclamation}, %{name}!"
      error: "%{name}, %{exclamation}!"
```

Provide a listener with a callback method:

```ruby
class MyListener
  def listen(event)
    puts event
    puts event.message
  end
end

listener = MyListener.new
```

Subscribe the listener, and publish the event:

```ruby
MyPublisher
  .new(luck: true)
  .subscribe(listener, :listen)
  .call
# => #<Informator::Event
#      @publisher=#<MyPublisher @attributes={ :luck => true }>,
#      @name=:success,
#      @attributes={ exclamation: "Wow" }
#    >
# => "Wow, success!"
```

```ruby
MyPublisher
  .new
  .subscribe(listener, :listen)
  .call
# => #<Informator::Event
#      @publisher=#<MyPublisher @attributes={}>,
#      @name=:success,
#      @attributes={ exclamation: "OMG" }
#    >
# => "error, OMG!"
```

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

Tested under rubies [compatible to MRI 1.9.3+](.travis.yml).

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
