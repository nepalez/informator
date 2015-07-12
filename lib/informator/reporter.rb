# encoding: utf-8

module Informator

  # Builds, collects and publishes events to selected subscribers
  #
  # @example
  #   reporter = Reporter.new
  #   reporter.events # => []
  #
  #   reporter.remember :success
  #   reporter.events # => [#<Event @type=:success @attributes={} @messages=[]>]
  #
  #   # this will call subscriber.notify for any event
  #   reporter.notify subscriber
  #   reporter.events # => []
  #
  # @api private
  #
  class Reporter

    # @private
    def initialize
      @events = []
      freeze # freezes the instance, but left events mutable!
    end

    # @!attribute [r] events
    # @return [Array<Informator::Event>]
    #   the list of registered events that havent'b been published yet
    attr_reader :events

    # @!method remember(type, messages, attributes)
    # Registers the event to be published to subscribers
    #
    # @param (see Informator::Event.new)
    #
    # @return [self] itself
    #
    def remember(*args)
      events << Event.new(*args)

      self
    end

    # Notifies subscribers on events registered since the last notification
    #
    # Mutates [#events] by excluding all events having been published.
    #
    # @param [Informator::Subscriber, Array<Informator::Subscriber>] subscribers
    #   the list of subscribers to be notified
    #
    # @return [Array<Informator::Event>] the list of published events
    def notify(*subscribers)
      events.dup.each { publish subscribers.flatten }
    end

    private

    def publish(subscribers)
      event = events.shift
      subscribers.each { |subscriber| subscriber.notify(event) }
    end

  end # class Reporter

end # module Informator
