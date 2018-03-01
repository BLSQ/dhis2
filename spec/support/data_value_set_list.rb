RSpec.shared_examples "a DHIS2 data value list" do |version:|

  let(:json_response) { fixture_content(version, "list", "data_value_sets.json") }

  before do
    stub_request(:get, "https://play.dhis2.org/demo/api/dataValueSets?orgUnit=eYcb2MlHGhk&period=201601&dataElementGroup=UJabOSRvwHI")
      .to_return(status: 200, body: json_response)
  end

  it "returns expected json" do
    result = client.data_value_sets.list({
      org_unit:           "eYcb2MlHGhk",
      period:             "201601",
      data_element_group: "UJabOSRvwHI"
    })
    expect(result).to be_an Array
    expect(result.first).to be_an OpenStruct
  end

  it "returns expected json" do
    result = client.data_value_sets.list({
      org_unit:           "eYcb2MlHGhk",
      period:             "201601",
      data_element_group: "UJabOSRvwHI"
    }, true)
    expect(result).to be_an Array
    expect(result.first).to be_a Hash
  end
end