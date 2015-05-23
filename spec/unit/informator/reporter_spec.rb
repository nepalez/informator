# encoding: utf-8

describe Informator::Reporter do

  subject(:reporter) { described_class.new }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe "#events" do

    subject { reporter.events }
    it { is_expected.to eql [] }

  end # describe #events

  describe "#remember" do

    subject { reporter.remember(*options) }

    let(:options) { [:foo, "bar", baz: :qux] }
    let(:event)   { Informator::Event.new(*options) }

    it "builds the event and adds it to #events" do
      expect { subject }.to change { reporter.events }.by [event]
    end

    it { is_expected.to eql reporter }

  end # describe #remember

  describe "#notify" do

    subject { reporter.notify(subscribers) }

    let(:subscribers) { 2.times.map { double notify: nil } }
    let!(:events) do
      %i(foo bar).each(&reporter.method(:remember))
      reporter.events.dup
    end

    it "notifies every subscriber on all #events" do
      events.each do |event|
        subscribers.each do |subscriber|
          expect(subscriber).to receive(:notify).with(event).ordered
        end
      end

      subject
    end

    it "clears #events" do
      expect { subject }.to change { reporter.events }.to []
    end

    context "when error occured while publishing" do

      before { allow(subscribers.first).to receive(:notify) { fail } }

      it "removes tried #events" do
        expect { subject rescue nil }
          .to change { reporter.events }
          .to [events.last]
      end

    end # context

    it { is_expected.to eql events }

  end # describe #notify

end # describe Informator::Reporter
