# encoding: utf-8

describe Informator::Event do

  let!(:pub_class) { Informator::Foo = Class.new                     }
  let(:publisher)  { pub_class.new                                   }
  let(:name)       { "success"                                       }
  let(:attributes) { { foo: :FOO }                                   }
  let(:event)      { described_class.new publisher, name, attributes }

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

  after { Informator.send :remove_const, :Foo }

end # describe Informator::Event
