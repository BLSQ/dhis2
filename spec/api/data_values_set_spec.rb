
# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::DataValueSet do

  describe "#create" do
    it "should return import status" do
      stub_request(:post, "https://play.dhis2.org/demo/api/dataValueSets").
             with(body: "{\"dataValues\":{\"de\":\"de\"}}").
             to_return(status: 200, body: "")

      status = Dhis2.client.data_value_sets.create( {de: "de"})
      expect(status).to be_a(Dhis2::Status)
    end
  end

  describe "#list" do
    it "should support by data_sets, orgUnit, periods" do
      stub_request(:get, "https://play.dhis2.org/demo/api/dataValueSets?children=true&dataSet=ds1&orgUnit=ou1&period=2017Q1")
        .to_return(status: 200, body: "", headers: {})

      Dhis2.client.data_value_sets.list(
        data_sets:         ["ds1"],
        periods:           ["2017Q1"],
        organisation_unit: "ou1"
      )
    end

    it "should support by data_sets, orgUnit array, periods" do
      stub_request(:get, "https://play.dhis2.org/demo/api/dataValueSets?children=true&dataSet=ds1&orgUnit=ou1&period=2017Q1")
        .to_return(status: 200, body: "", headers: {})

      Dhis2.client.data_value_sets.list(
        data_sets:         ["ds1"],
        periods:           ["2017Q1"],
        organisation_unit: ["ou1"]
      )
    end

    it "should support by data_element_groups, organisation_unit_group, start date and end date" do
      stub_request(:get, ["https://play.dhis2.org/demo/api/dataValueSets?",
                          "dataElementGroup=de_group1",
                          "&endDate=2015-02-28",
                          "&orgUnitGroup=ougroup1",
                          "&startDate=2015-01-31"].join)
        .to_return(status: 200, body: fixture_content(:dhis2, "data_value_sets.json"))

      data_values = Dhis2.client.data_value_sets.list(
        organisation_unit_group: "ougroup1",
        data_element_groups:     ["de_group1"],
        start_date:              Date.parse("31-1-2015"),
        end_date:                Date.parse("28-02-2015")
      )

      expect(data_values.values.first).to be_a OpenStruct
    end
  end
end
