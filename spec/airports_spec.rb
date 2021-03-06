require 'spec_helper'

RSpec.describe Airports do
  it "has a version number" do
    expect(Airports::VERSION).not_to be nil
  end

  describe ".find_by_iata_code" do
    subject(:find_by_iata_code) do
      described_class.find_by_iata_code(iata_code)
    end

    context "with a valid IATA code" do
      let(:iata_code) { "LHR" }

      it { is_expected.to be_a(Airports::Airport) }
      its(:name) { is_expected.to eq("Heathrow") }
    end

    context "with an invalid IATA code" do
      let(:iata_code) { "LOL" }

      it { is_expected.to be_nil }

      context "with a code that is too long" do
        let(:iata_code) { "ALICE" }

        it "doesn't try to look it up" do
          expect(Airports.parsed_data).not_to receive(:fetch).with(iata_code, nil)
          find_by_iata_code
        end
      end
    end
  end

  describe ".iata_codes" do
    subject { described_class.iata_codes }

    it { is_expected.to be_a(Array) }
    it { is_expected.to include("LHR") }
  end

  describe ".all" do
    subject { described_class.all }

    it { is_expected.to be_a(Array) }
    its(:first) { is_expected.to be_a(Airports::Airport) }
  end
end
