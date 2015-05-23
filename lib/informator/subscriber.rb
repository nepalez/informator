# encoding: utf-8

module Informator

  # Class Subscriber wraps the [#object] along with its [#callback] method
  # to receive event notifications.
  #
  # @example The method [#notify] sends event to the [#object] via [#callback]
  #   object     = Struct.new(:event).new
  #   subscriber = Subscriber.new object, :event=
  #   subscriber.frozen? # => true
  #
  #   event  = Informator::Event.new :success
  #   # => #<Event @type=:success @data={} @messages=[]>
  #
  #   subscriber.notify event
  #   object.event
  #   # => #<Event @type=:success @data={} @messages=[]>
  #
  # @api private
  #
  class Subscriber

    include Comparable

    # @!attribute [r] object
    #
    # @return [Object] the object to send events to
    #
    attr_reader :object

    # @!attribute [r] callback
    #
    # @return [Symbol] the name of the object methods to listen to events
    #
    attr_reader :callback

    # @!scope class
    # @!method new(object, callback)
    # Builds the subscriber for given object and callback
    #
    # @param [Object] object
    # @param [#to_sym] callback (:receive)
    #
    # @return [Informator::Subscriber]

    # @private
    def initialize(object, callback = :receive)
      @object   = object
      @callback = callback.to_sym
      freeze
    end

    # Sends the event to the subscriber object via its callback
    #
    # @param [Informator::Event] event
    #
    # @return [Informator::Event] published event
    #
    def notify(event)
      object.public_send callback, event

      event
    end

    # Compares the subscriber to another one by their objects and callbacks
    #
    # @param [Object] other
    #
    # @return [Boolean]
    #
    def ==(other)
      other.instance_of?(self.class) ? other.value.eql?(value) : false
    end

    protected

    # Returns value to compare subscribers by
    #
    # @return [Array]
    #
    def value
      [object, callback]
    end

  end # class Subscriber

end # module Informator
