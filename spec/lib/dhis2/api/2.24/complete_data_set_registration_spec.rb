# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version224::CompleteDataSetRegistration do
  let(:client) { build_client("2.24") }
  let(:get_response) {
    {
      "complete_data_set_registrations" => 
      [
        {"period"=>"201701", "data_set"=>"uayRvSKFbhu", "organisation_unit"=>"Tht0fnjagHi", "attribute_option_combo"=>"HllvX50cXC0", "date"=>"2018-12-11", "stored_by"=>"admin"},
        {"period"=>"201701", "data_set"=>"uayRvSKFbhu", "organisation_unit"=>"VrDA0Hn4Xc6", "attribute_option_combo"=>"HllvX50cXC0", "date"=>"2018-12-11", "stored_by"=>"admin"}
      ]
    }
  }
  let(:empty_response) {
    {}
  }

  it "list complete data set registrations" do
    stub_request(:get, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?dataSet=HllvX50cXC0&dataSet=HllvX50cXC1&orgUnit=Tht0fnjagHi&orgUnit=VrDA0Hn4Xc6&period=201701&period=201702")
      .to_return(status: 200, body: fixture_content("2.24", "list", "complete_data_set_registrations.json"))

    response = described_class.list(client, periods: ["201701","201702"], organisation_units: ["Tht0fnjagHi","VrDA0Hn4Xc6"], data_sets: ["HllvX50cXC0","HllvX50cXC1"])
    expect(a_request(:get, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?dataSet=HllvX50cXC0&dataSet=HllvX50cXC1&orgUnit=Tht0fnjagHi&orgUnit=VrDA0Hn4Xc6&period=201701&period=201702")).to have_been_made.once
    expect(response).to eq get_response
  end

  it "create complete data set registration" do
    stub_request(:post, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?ds=HllvX50cXC0&ou=Tht0fnjagHi&pe=201701")
    .to_return(status: 204)

    response = described_class.create(client, period: "201701", organisation_unit: "Tht0fnjagHi", data_set: "HllvX50cXC0")
    expect(a_request(:post, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?ds=HllvX50cXC0&ou=Tht0fnjagHi&pe=201701")).to have_been_made.once
    expect(response).to eq empty_response
  end

  it "deletes complete data set registration" do
    stub_request(:delete, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?ds=HllvX50cXC0&ou=Tht0fnjagHi&pe=201701")
    .to_return(status: 204)

    response = described_class.delete(client, period: "201701", organisation_unit: "Tht0fnjagHi", data_set: "HllvX50cXC0")

    expect(a_request(:delete, "https://play.dhis2.org/demo/api/completeDataSetRegistrations?ds=HllvX50cXC0&ou=Tht0fnjagHi&pe=201701")).to have_been_made.once
    expect(response).to eq empty_response
  end
end
