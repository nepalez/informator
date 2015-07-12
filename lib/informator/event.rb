# encoding: utf-8

module Informator

  # Class Event provides an immutable container for hash of some attributes, to
  # which a type is attached. It also contains an array of human-readable
  # messages describing the event.
  #
  # The primary goal of events is folding attributes to be returned and/or sent
  # between various objects into unified format.
  #
  # @example
  #   event = Event[:success, "bingo!", foo: :bar]
  #   # <Event @type=:success @messages=["bingo!"] @attributes={ :foo => :bar }>
  #
  #   event.frozen?
  #   # => true
  #
  class Event

    include Equalizer.new(:type, :attributes)

    # @!attribute [r] type
    #
    # @return [Symbol] the type of the event
    #
    attr_reader :type

    # @!attribute [r] attributes
    #
    # @return [Hash] the event-specific attributes
    #
    attr_reader :attributes

    # @!attribute [r] messages
    #
    # @return [Array<String>] human-readable messages, describing the event
    #
    attr_reader :messages

    # @!scope class
    # @!method [](type, messages, attributes)
    # Builds the event
    #
    # @param [#to_sym] type
    # @param [#to_s, Array<#to_s>] messages
    # @param [Hash] attributes
    #
    # @return [Informator::Event]
    def self.[](*args)
      new(*args)
    end

    # @private
    def initialize(type, *messages, **attributes)
      @type     = type.to_sym
      @messages = messages.flatten.map(&:to_s)
      @attributes     = attributes
      IceNine.deep_freeze(self)
    end

  end # class Event

end # module Informator
