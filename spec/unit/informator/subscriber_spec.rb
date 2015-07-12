# encoding: utf-8

describe Informator::Subscriber do

  let(:callback) { "foo" }
  let(:event)    { double }
  let(:object)   { double callback.to_sym => callback, freeze: nil }

  subject(:subscriber) { described_class.new object, callback }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#object" do

    subject { subscriber.object }
    it { is_expected.to eql object }

  end # describe #object

  describe "#callback" do

    subject { subscriber.callback }
    it { is_expected.to eql callback.to_sym }

    context "when callback isn't defined" do

      let(:subscriber) { described_class.new object }
      it { is_expected.to eql :receive }

    end # context

  end # describe #callback

  describe "#notify" do

    subject { subscriber.notify event }

    it "sends event to object via callback" do
      expect(object).to receive(callback).with(event)
      subject
    end

    it { is_expected.to eql event }

  end # describe #notify

  describe "#==" do

    subject { subscriber == other }

    context "to subscriber with the same object and callback" do

      let(:other) { subscriber.dup }
      it { is_expected.to eql true }

    end # context

    context "to event with another object" do

      let(:other) { double freeze: nil }
      it { is_expected.to eql false }

    end # context

    context "to event with other data" do

      let(:other) { described_class.new object, :other }
      it { is_expected.to eql false }

    end # context

    context "to non-subscriber" do

      let(:other) { :foo }
      it { is_expected.to eql false }

    end # context

  end # describe #==

end # describe Informator::Subscriber
