# encoding: utf-8

module Informator

  # Describes a subscriber for publisher's notifications
  #
  # @api private
  #
  class Subscriber

    # @!attribute [r] listener
    #
    # @return [Object] The listener to send events to
    #
    attr_reader :listener

    # @!attribute [r] callback
    #
    # @return [Symbol] The name of the listener's method that receives events
    #
    attr_reader :callback

    # @!scope class
    # @!method new(listener, callback)
    # Builds the subscriber for given listener and callback
    #
    # @param [Object] listener
    # @param [#to_sym] callback
    #
    # @return [Informator::Subscriber]

    # @private
    def initialize(listener, callback)
      @listener = listener
      @callback = callback.to_sym
      IceNine.deep_freeze(self)
    end

    # Sends the event to the subscriber listener via its callback
    #
    # @param [Informator::Event] event
    #
    # @return [Informator::Event] published event
    #
    def notify(event)
      listener.public_send callback, event
      event
    end

  end # class Subscriber

end # module Informator
