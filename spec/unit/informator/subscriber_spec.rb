# encoding: utf-8

describe Informator::Subscriber do

  let(:callback)   { "foo"                                    }
  let(:event)      { double                                   }
  let(:listener)   { double callback => callback, freeze: nil }
  let(:subscriber) { described_class.new listener, callback   }

  describe ".new" do

    subject { subscriber }
    it { is_expected.to be_frozen }

  end # describe .new

  describe "#listener" do

    subject { subscriber.listener }
    it { is_expected.to eql listener }

  end # describe #listener

  describe "#callback" do

    subject { subscriber.callback }
    it { is_expected.to eql callback.to_sym }

  end # describe #callback

  describe "#==" do

    subject { subscriber == other }

    context "with the same listeners and callbacks" do

      let(:other) { described_class.new listener, callback }
      it { is_expected.to eql true }

    end # context

    context "with different listeners" do

      let(:other) { described_class.new double(freeze: nil), callback }
      it { is_expected.to eql false }

    end # context

    context "with different callbacks" do

      let(:other) { described_class.new listener, "other" }
      it { is_expected.to eql false }

    end # context

  end # describe #==

  describe "#notify" do

    subject { subscriber.notify event }

    it "sends event to listener via callback" do
      expect(listener).to receive(callback).with(event)
      subject
    end

    it { is_expected.to eql event }

  end # describe #notify

end # describe Informator::Subscriber
