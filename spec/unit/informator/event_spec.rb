# encoding: utf-8

describe Informator::Event do

  subject(:event) { described_class.new type, :foo, [:bar], baz: :qux }

  let(:type) { "success" }

  describe ".new" do

    it { is_expected.to be_frozen }

  end # describe .new

  describe ".[]" do

    before { allow(described_class).to receive(:new) }

    it "builds the event" do
      expect(described_class).to receive(:new).with(:foo, :bar, :baz)
      described_class[:foo, :bar, :baz]
    end

  end # describe .new

  describe "#type" do

    subject { event.type }
    it { is_expected.to eql type.to_sym }

  end # describe #type

  describe "#messages" do

    subject { event.messages }
    it { is_expected.to eql %w(foo bar) }

  end # describe #messages

  describe "#data" do

    subject { event.data }
    it { is_expected.to eq(baz: :qux) }

  end # describe #data

  describe "#==" do

    subject { event == other }

    context "to event with the same type and data" do

      let(:other) { Class.new(described_class).new type, baz: :qux }
      it { is_expected.to eql true }

    end # context

    context "to event with another type" do

      let(:other) { described_class.new :error, baz: :qux }
      it { is_expected.to eql false }

    end # context

    context "to event with other data" do

      let(:other) { described_class.new :success, baz: "qux" }
      it { is_expected.to eql false }

    end # context

    context "to non-event" do

      let(:other) { :foo }
      it { is_expected.to eql false }

    end # context

  end # describe #==

end # describe Informator::Event
