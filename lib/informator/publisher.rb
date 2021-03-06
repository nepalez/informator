# encoding: utf-8

module Informator

  # The base class for publishers
  #
  # @api public
  #
  class Publisher

    include Comparable

    # @!attribute [r] subscribers
    #
    # @return [Array<Informator::Subscriber>] The list of subscribers
    #
    attr_reader :subscribers

    # @!attribute [r] attributes
    #
    # @return [Hash] Initialized attributes
    #
    attr_reader :attributes

    # @!scope class
    # @!method new(attributes = {})
    # Creates the immutable publisher
    #
    # @param [Hash] attributes
    #
    # @return [Informator::Publisher]

    # @private
    def initialize(attributes = {})
      @attributes  = Hash[attributes]
      @subscribers = block_given? ? yield : Set.new
      IceNine.deep_freeze(self)
    end

    # Returns a new publisher with the listener being added to its subscribers
    #
    # @param [Object] listener
    # @param [Symbol, String] callback
    #   The name of the listener method, that should receive events
    #   The method is expected to accept one argument (for the event)
    #
    # @return (see .new)
    #
    def subscribe(listener, callback)
      subscriber = Subscriber.new(listener, callback)
      self.class.new(attributes) { subscribers | [subscriber] }
    end

    # Creates the immutable event and sends it to all subscribers
    #
    # @param [#to_sym] name The name of the event
    # @param [Hash] arguments The arguments of the event
    #
    # @return [Informator::Event] The published event
    #
    def publish(name, arguments)
      event = Event.new(self, name, arguments)
      subscribers.each { |subscriber| subscriber.notify(event) }
      event
    end

    # Does the same as [#publish], and then throws the `:published` exception,
    # that carries an event
    #
    # @param (see #publish)
    #
    # @return (see #publish)
    #
    # @raise [UncaughtThrowError] The exception to be catched later
    #
    def publish!(name, arguments)
      event = publish(name, arguments)
      throw :published, event
    end

    # Treats two publishers of the same class with the same attributes as equal
    #
    # @param [Object] other
    #
    # @return [Boolean]
    #
    def ==(other)
      other.instance_of?(self.class) && attributes.eql?(other.attributes)
    end
    alias_method :eql?, :==

    # Human-readable description of the publisher
    #
    # @return [String]
    #
    def inspect
      "#<#{self.class} @attributes=#{attributes}>"
    end
    alias_method :to_s, :inspect

  end # class Publisher

end # module Informator
