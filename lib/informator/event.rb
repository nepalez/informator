# encoding: utf-8

module Informator

  # Class Event provides an immutable container for hash of some data, to
  # which a type is attached. It also contains an array of human-readable
  # messages describing the event.
  #
  # The primary goal of events is folding data to be returned and/or sent
  # between various objects into unified format.
  #
  # @example
  #   event = Event.new :success, "bingo!", foo: :bar
  #   # => #<Event @type=:success, @messages=["bingo!"], @data={ :foo => :bar }>
  #   event.frozen?
  #   # => true
  #
  class Event

    include Comparable

    # @!attribute [r] type
    #
    # @return [Symbol] the type of the event
    #
    attr_reader :type

    # @!attribute [r] data
    #
    # @return [Hash] the event-specific data
    #
    attr_reader :data

    # @!attribute [r] messages
    #
    # @return [Array<String>] human-readable messages, describing the event
    #
    attr_reader :messages

    # @!scope class
    # @!method new(type, messages, data)
    # Builds the event
    #
    # @param [#to_sym] type
    # @param [#to_s, Array<#to_s>] messages
    # @param [Hash] data
    #
    # @return [Informator::Event]

    # @private
    def initialize(type, *messages, **data)
      @type     = type.to_sym
      @messages = messages.flatten.map(&:to_s)
      @data     = data
      freeze
    end

    # Compares the event to another one by their types and data
    #
    # @param [Object] other
    #
    # @return [Boolean]
    #
    def ==(other)
      other.is_a?(self.class) && other.value.eql?(value)
    end

    protected

    # Returns value to compare events by
    #
    # @return [Array]
    #
    def value
      [type, data]
    end

  end # class Event

end # module Informator