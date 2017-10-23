# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version224::DataValue do

  let(:client) { build_client("2.24") }

  it "can be found" do
    stub_request(:get, "https://play.dhis2.org/demo/api/dataValues?pe=201601&de=LrbgRnYURZT&ou=eYcb2MlHGhk")
      .to_return(status: 200, body: fixture_content("2.24", "list", "data_values.json"))

    response = described_class.find(client, period: "201601", organisation_unit: "eYcb2MlHGhk", data_element: "LrbgRnYURZT")

    expect(response).to eq "36"
  end
end
