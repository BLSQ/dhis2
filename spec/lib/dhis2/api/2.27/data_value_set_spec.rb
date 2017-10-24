# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version227::DataValueSet do
  let(:client) { build_client("2.27") }

  it_behaves_like "a DHIS2 creatable resource", version: "2.27", nil_id: true

  describe ".list" do
    let(:json_response) { fixture_content("2.27", "list", "data_value_sets.json") }

    before do
      stub_request(:get, "https://play.dhis2.org/demo/api/dataValueSets?orgUnit=eYcb2MlHGhk&period=201601&dataElementGroup=UJabOSRvwHI")
        .to_return(status: 200, body: json_response)
    end

    it "returns expected json" do
      result = client.data_value_sets.list(
        org_unit: "eYcb2MlHGhk",
        period:   "201601",
        data_element_group: "UJabOSRvwHI"
      )
      expect(result["data_values"]).to be_an Array
    end
  end
end