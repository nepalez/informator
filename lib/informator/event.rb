# encoding: utf-8

module Informator

  # Describes events provided by publishers and being sent to their subscribers
  #
  # @api public
  #
  class Event

    include Equalizer.new(:publisher, :name, :attributes, :time)

    # @!attribute [r] publisher
    #
    # @return [Informator::Publisher] The source of the event
    #
    attr_reader :publisher

    # @!attribute [r] name
    #
    # @return [Symbol] The name of the event
    #
    attr_reader :name

    # @!attribute [r] attributes
    #
    # @return [Hash] The event-specific attributes
    #
    attr_reader :attributes

    # @!attribute [r] time
    #
    # @return [Time] The time the event was created
    #
    attr_reader :time

    # @!scope class
    # @!method new(publisher, name, attributes)
    # Builds the event
    #
    # @param [Informator::Publisher]
    # @param [#to_sym] name
    # @param [Hash] attributes
    #
    # @return [Informator::Event]
    #
    # @api private

    # @private
    def initialize(publisher, name, attributes = {})
      @publisher  = publisher
      @name       = name.to_sym
      @attributes = Hash[attributes]
      @time       = Time.now
      IceNine.deep_freeze(self)
    end

    # The human-readable message for the event
    #
    # @return [String]
    #
    def message
      scope = [:informator, Inflecto.underscore(publisher.class)]
      I18n.translate(name, attributes.merge(scope: scope)).freeze
    end

  end # class Event

end # module Informator
