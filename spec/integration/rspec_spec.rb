# encoding: utf-8

require "informator/rspec"
require "timecop"
require_relative "i18n"

describe "shared examples" do

  include_context :preloaded_translations

  before do
    class Informator::Foo < Informator::Publisher
      def call
        if attributes[:exclamation] == "Wow"
          publish :success, attributes
        else
          publish :error, attributes
        end
      end
    end
    Timecop.freeze
  end

  let(:lucky)    { Informator::Foo.new exclamation: "Wow" }
  let(:unlucky)  { Informator::Foo.new exclamation: "OMG" }

  let(:listener) { double callback => nil, freeze: nil }
  let(:callback) { :call }

  it_behaves_like :publishing_event do
    subject { lucky.subscribe(listener, callback).call }

    let(:event) { Informator::Event.new lucky, :success, exclamation: "Wow" }
    let(:event_message) { "publisher said: Wow!" }
  end

  it_behaves_like :publishing_event do
    subject { unlucky.subscribe(listener, callback).call }
    let(:locale) { :fr }

    let(:event_name)       { :error                 }
    let(:event_attributes) { { exclamation: "OMG" } }
    let(:event_message)    { "éditeur dit: OMG!"    }
  end

  after do
    Timecop.return
    Informator.send :remove_const, :Foo
  end

end # describe shared examples
