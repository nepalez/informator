# encoding: utf-8

require "equalizer"

describe Informator::Publisher do

  before do
    Informator::Subscriber
      .send :include, Equalizer.new(:listener, :callback)
    Informator::Event
      .send :include, Equalizer.new(:publisher, :name, :attributes)
    Informator::Publisher
      .send :include, Equalizer.new(:attributes)
  end

  let(:pub_class)  { Informator::Foo = Class.new(described_class)      }
  let(:publisher)  { pub_class.new attributes                          }
  let(:attributes) { { foo: :FOO, bar: :BAR }                          }
  let(:listener)   { double callback => nil, freeze: nil               }
  let(:callback)   { :call                                             }
  let(:name)       { :foo                                              }
  let(:subscriber) { Informator::Subscriber.new listener, callback     }
  let(:event)      { Informator::Event.new publisher, name, attributes }

  describe ".new" do

    subject { publisher }

    it { is_expected.to be_frozen }

    it "doesn't freeze attirbutes" do
      expect { subject }.not_to change { attributes.frozen? }
    end

  end # describe .new

  describe "#attributes" do

    subject { publisher.attributes }

    it { is_expected.to be_frozen      }
    it { is_expected.to eql attributes }

    context "by default" do

      let(:publisher) { pub_class.new }

      it { is_expected.to eql({}) }

    end # context

  end # describe #attributes

  describe "#subscribers" do

    subject { publisher.subscribers }

    it { is_expected.to eql []    }
    it { is_expected.to be_frozen }

  end # describe #attributes

  describe "#subscribe" do

    subject { publisher.subscribe(listener, callback) }

    it { is_expected.to be_kind_of described_class }

    it "preserves attributes" do
      expect(subject.attributes).to eql attributes
    end

    it "registers the subscriber" do
      expect(subject.subscribers).to eql [subscriber]
    end

    it "preserves subscribers" do
      updated = subject.subscribe(listener, callback)
      expect(updated.subscribers).to eql [subscriber, subscriber]
    end

  end # describe #subscribe

  describe "#publish" do

    subject { publisher.subscribe(listener, callback).publish name, attributes }

    it "sends event to subscribers" do
      expect(listener).to receive(callback).with(event)
      subject
    end

    it { is_expected.to eql event }

  end # describe #publish

  describe "#publish!" do

    subject { publisher.subscribe(listener, callback).publish! name, attributes }

    it "sends event to subscribers" do
      expect(listener).to receive(callback).with(event)
      subject rescue nil
    end

    it "throws an exception" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "carries the event" do
      expect(catch(:published) { subject }).to eql event
    end

  end # describe #publish!

  after { Informator.send :remove_const, :Foo }

end # describe Informator::Publisher
