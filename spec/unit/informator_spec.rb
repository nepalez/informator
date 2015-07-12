# encoding: utf-8

describe Informator do

  subject(:informator) { klass.new }

  let(:klass)    { Class.new { include Informator } }
  let(:callback) { :on_received }
  let(:listener) do
    double(
      callback => nil,
      foo: nil,
      bar: nil,
      receive: nil,
      freeze: nil
    )
  end

  before { informator.subscribe listener, callback }

  describe "#subscribe" do

    it "subscribes listeners one-by-one" do
      informator.subscribe(listener, :foo).subscribe(listener, :bar)

      expect(listener).to receive(callback).ordered
      expect(listener).to receive(:foo).ordered
      expect(listener).to receive(:bar).ordered
      informator.publish :info
    end

    it "doesn't duplicate listener's callbacks" do
      informator.subscribe(listener, callback)

      expect(listener).to receive(callback).once
      informator.publish :info
    end

    it "subscribes listener with :receive callback by default" do
      informator.subscribe(listener)

      expect(listener).to receive(:receive)
      informator.publish :info
    end

  end # describe #subscribe

  describe "#remember" do

    it "keeps remembered events unpublished" do
      expect(listener).not_to receive(callback)

      informator.remember :info
    end

    it "remembers events until publishing" do
      expect(listener).to receive(callback).once

      informator.remember :info
      informator.publish
    end

    it "returns itself to allow chaining" do
      expect(informator.remember(:info).remember(:alert)).to eql informator
    end

  end # describe #remember

  describe "#publish" do

    it "publishes events" do
      expect(listener).to receive(callback) do |event|
        expect(event).to be_kind_of Informator::Event
        expect(event.type).to eq :alert
        expect(event.messages).to eql %w(foo)
        expect(event.attributes).to eql(bar: :baz)
      end

      informator.publish :alert, "foo", bar: :baz
    end

    it "publishes all remembered events at once" do
      expect(listener).to receive(callback).twice

      informator.remember :info
      informator.publish  :alert
    end

    it "can publish only remembered events without a new one" do
      expect(listener).to receive(callback).once

      informator.remember :info
      informator.publish
    end

    it "returns events having been published" do
      informator.remember :info
      events = informator.publish :alert

      expect(events).to be_kind_of Array
      expect(events.map(&:class).uniq).to contain_exactly Informator::Event
      expect(events.map(&:type)).to eql [:info, :alert]
    end

    it "forgets published events" do
      informator.publish :info
      expect(listener).not_to receive(callback)

      informator.publish
    end

  end # describe #publish

  describe "#publish!" do

    it "publishes all remembered events at once" do
      expect(listener).to receive(callback).twice

      informator.remember :info
      informator.publish!(:alert) rescue nil
    end

    it "can publish only remembered events without a new one" do
      expect(listener).to receive(callback).once

      informator.remember :info
      informator.publish! rescue nil
    end

    it "forgets published events" do
      informator.publish! :info rescue nil
      expect(listener).not_to receive(callback)

      informator.publish
    end

    it "throws :published" do
      expect { informator.publish! }.to raise_error(ArgumentError)
      expect { catch(:published) { informator.publish! } }.not_to raise_error
    end

    it "throws events having been published" do
      informator.remember :info
      events = catch(:published) { informator.publish! :alert }

      expect(events).to be_kind_of Array
      expect(events.map(&:class).uniq).to contain_exactly Informator::Event
      expect(events.map(&:type)).to eql [:info, :alert]
    end

  end # describe #publish!

end # describe Informator
