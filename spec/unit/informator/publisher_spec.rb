# encoding: utf-8

require "timecop"

describe Informator::Publisher do

  before { Timecop.freeze } # to allow time-dependent events being equal
  after  { Timecop.return }

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

  describe "#==" do

    subject { publisher == other }

    context "with the same types and attributes" do

      let(:other) { publisher.subscribe(listener, callback) }
      it { is_expected.to eql true }

    end # context

    context "with different types" do

      let(:other) { described_class.new(attributes) }
      it { is_expected.to eql false }

    end # context

    context "with different attributes" do

      let(:other) { pub_class.new }
      it { is_expected.to eql false }

    end # context

  end # describe #==

  describe "#eql?" do

    subject { publisher == other }
    let(:other) { publisher.subscribe(listener, callback) }

    it "aliases #==" do
      expect(subject).to eql true
    end

  end # describe #==

  describe "#inspect" do

    subject { publisher.inspect }
    it { is_expected.to eql "#<Informator::Foo @attributes=#{attributes}>" }

  end # describe #inspect

  describe "#to_s" do

    subject { publisher.to_s }
    it { is_expected.to eql publisher.inspect }

  end # describe #to_s

  describe "#subscribers" do

    subject { publisher.subscribers }

    it { is_expected.to eql Set.new }
    it { is_expected.to be_frozen }

  end # describe #attributes

  describe "#subscribe" do

    subject { publisher.subscribe(listener, callback) }

    it { is_expected.to be_kind_of described_class }

    it "preserves attributes" do
      expect(subject.attributes).to eql attributes
    end

    it "registers new subscriber" do
      other = Informator::Subscriber.new listener, "other"

      updated = subject.subscribe(listener, "other")
      expect(updated.subscribers).to contain_exactly subscriber, other
    end

    it "skips registered subscriber" do
      updated = subject.subscribe(listener, callback)
      expect(updated.subscribers).to contain_exactly subscriber
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

    let(:caller) { publisher.subscribe(listener, callback) }
    subject { caller.publish! name, attributes }

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
