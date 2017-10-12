# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Event do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#id" do
    let(:event) { described_class.new(Dhis2.client, { event: 'abc' }) }

    it "returns event as id" do
      expect(event.id).to eq event.event
    end
  end
end
