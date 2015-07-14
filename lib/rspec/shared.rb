# encoding: utf-8

shared_context :event_translations do

  let(:__locale__) { defined?(locale) ? locale : :en }

  around do |example|
    old, I18n.locale = I18n.locale, __locale__
    example.run
    I18n.locale = old
  end

end # shared context

# @example
#   it_behaves_like :publishing_event do
#
#     # required settings for the specification
#     subject { MyPublisher.new(attributes).subscribe(listener, callback).call }
#     let(:listener) { double callback => nil } # required
#     let(:callback) { "foo"     }              # required
#
#     # optional settings
#     let(:event) { Event.new publisher, :success, exclamation: "Wow" }
#     let(:event_name)       { :success               } # The name of the event
#     let(:event_attributes) { { exclamation: "Wow" } } # The attributes for the event
#     let(:locale)           { :en                    } # :en by default
#     let(:event_message)    { "Wow, success!"        } # The message
#
#   end
#
shared_examples :publishing_event do

  include_context :event_translations

  before do
    fail SyntaxError.new "subject should be defined"  unless defined? subject
    fail SyntaxError.new "listener should be defined" unless defined? listener
    fail SyntaxError.new "callback should be defined" unless defined? callback
  end

  it "[publishes event]" do
    expect(listener).to receive(callback) do |received|
      if defined? event
        expect(received).to eql(event), <<-REPORT.gsub(/ *\|/, "")
          |
          |#{listener}##{callback} should have received the event:
          |
          |  expected: #{event.inspect}
          |       got: #{received.inspect}
        REPORT
      else
        expect(received)
          .to be_kind_of(Informator::Event), <<-REPORT.gsub(/ *\|/, "")
            |
            |#{listener}##{callback} should have received an event.
            |
            |  expected: instance of Informator::Event subclass
            |       got: #{received.inspect}
          REPORT

        if defined? event_name
          expect(received.name)
            .to eql(event_name), <<-REPORT.gsub(/ *\|/, "")
              |
              |#{listener}##{callback} should have received an event with the name:
              |
              |  expected: #{event_name}
              |       got: #{received.name}
              |from event: #{received.inspect}
            REPORT
        end

        if defined? event_attributes
          expect(received.attributes)
            .to eql(event_attributes), <<-REPORT.gsub(/ *\|/, "")
              |
              |#{listener}##{callback} should have received an event with the attributes:
              |
              |  expected: #{event_attributes}
              |       got: #{received.attributes}
              |from event: #{received.inspect}
            REPORT
        end
      end

      if defined? event_message
        expect(received.message)
          .to eql(event_message), <<-REPORT.gsub(/ *\|/, "")
            |
            |Language: #{__locale__.to_s.upcase}
            |#{listener}##{callback} should have received an event with the message:
            |
            |  expected: #{event_message}
            |       got: #{received.message}
            |from event: #{received.inspect}
          REPORT
      end
    end

    subject
  end

end # shared examples
