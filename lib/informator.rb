# encoding: utf-8

require "ice_nine"
require "equalizer"

require_relative "informator/event"
require_relative "informator/subscriber"
require_relative "informator/reporter"

# The module provides subscribe/publish/report features
#
module Informator

  # Subscribes the listener for receiving events notifications via callback
  #
  # @param [Object] listener
  #   The object to send events to
  # @param [#to_sym] callback (:receive)
  #   The name of the listener method to send events through
  #
  # @return [self] itself
  #
  def subscribe(listener, callback = :receive)
    sub = Subscriber.new(listener, callback)
    __subscribers__ << sub unless __subscribers__.include? sub

    self
  end

  # @!method remember(type, messages, attributes)
  # Builds and stores the event waiting for being published
  #
  # @param (see Informator::Event.new)
  #
  # @return [self] itself
  #
  def remember(*args)
    __reporter__.remember(*args)

    self
  end

  # @overload publish(type, messages, attributes)
  #   Builds the event and then publishes all unpublished events
  #
  #   @param (see #remember)
  #
  # @overload publish
  #   Publishes all unpublished events without adding a new one
  #
  # @return [Array<Informator::Event>] list of events having been published
  #
  def publish(*args)
    remember(*args) if args.any?
    __reporter__.notify __subscribers__
  end

  # The same as `publish` except for it throws `:published` afterwards
  #
  # @overload publish(type, messages, attributes)
  #   Builds the event and then publishes all unpublished events
  #
  #   @param (see #remember)
  #
  # @overload publish
  #   Publishes all unpublished events without adding a new one
  #
  # @raise [UncaughtThrowError, ArgumentError]
  #   for `:published` events being carried
  #
  def publish!(*args)
    throw :published, publish(*args)
  end

  private

  def __reporter__
    @__reporter__ ||= Reporter.new
  end

  def __subscribers__
    @__subscribers__ ||= []
  end

end # module Informator
