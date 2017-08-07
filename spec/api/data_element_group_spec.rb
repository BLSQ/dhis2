# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::DataElementGroup do
  it "should create and map data elements if necessary" do
    stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
      .with(body: JSON.generate(
        "dataElementGroups" => [
          { "name"         => "group_name",
            "shortName"    => "short_name",
            "code"         => "code",
            "dataElements" => [
              { "id"=>"de_id1" }, { "id"=>"de_id2" }
            ] }
        ]
      ))
      .to_return(status: 200, body: "")

    status = Dhis2.client.data_element_groups.create(
      [
        {
          name:          "group_name",
          short_name:    "short_name",
          code:          "code",
          data_elements: [
            { id: "de_id1" },
            { id: "de_id2" }
          ]
        }
      ]
    )

    expect(status).to be_a(Dhis2::Status)
  end
end