# encoding: utf-8

require "timecop"

describe Informator::Event do

  let!(:pub_class) { Informator::Foo = Class.new                     }
  let(:publisher)  { pub_class.new                                   }
  let(:name)       { "success"                                       }
  let(:attributes) { { foo: :FOO }                                   }
  let(:event)      { described_class.new publisher, name, attributes }

  before { Timecop.freeze }
  after  { Timecop.return }

  describe ".new" do

    subject { event }

    it { is_expected.to be_frozen }

    it "doesn't freeze attributes" do
      expect { subject }.not_to change { attributes.frozen? }
    end

  end # describe .new

  describe "#publisher" do

    subject { event.publisher }

    it { is_expected.to eql publisher }
    it { is_expected.to be_frozen     }

  end # describe #publisher

  describe "#name" do

    subject { event.name }

    it { is_expected.to eql name.to_sym }

  end # describe #name

  describe "#attributes" do

    subject { event.attributes }

    it { is_expected.to eql attributes }
    it { is_expected.to be_frozen      }

  end # describe #attributes

  describe "#time" do

    subject { event.time }

    it "returns the time of event" do
      expect(subject).to eql Time.now
    end

  end # describe #time

  describe "#message" do

    subject { event.message }

    it do
      is_expected
        .to eql "translation missing: en.informator.informator/foo.success"
    end

    it 'gives event attributes to translator' do
      expect(I18n).to receive(:translate) do |_, opts|
        expect(opts.merge(attributes)).to eql opts
      end
      subject
    end

    it { is_expected.to be_frozen }

  end # describe #message

  describe "#==" do

    subject { event == other }

    context "with the same publisher, times, names and attributes" do

      let(:other) { described_class.new publisher, name, attributes }
      it { is_expected.to eql true }

    end # context

    context "with different publishers" do

      let(:new_publisher) { Informator::Publisher.new }

      let(:other) { described_class.new new_publisher, name, attributes }
      it { is_expected.to eql false }

    end # context

    context "with different times" do

      let!(:event) { described_class.new publisher, name, attributes }
      let!(:other) do
        new_time = Time.now + 1
        Timecop.travel(new_time)
        described_class.new publisher, name, attributes
      end

      it { is_expected.to eql false }

    end # context

    context "with different names" do

      let(:other) { described_class.new publisher, "other", attributes }
      it { is_expected.to eql false }

    end # context

    context "with different attributes" do

      let(:other) { described_class.new publisher, "other" }
      it { is_expected.to eql false }

    end # context

  end # describe #==

  after { Informator.send :remove_const, :Foo }

end # describe Informator::Event
