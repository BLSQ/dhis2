# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Analytic do
  it "should list by dimension ou, dx, pe and extra filter" do
    stub_request(:get, "https://play.dhis2.org/demo/api/analytics?dimension=pe:%5B%222016Q1%22,%20%222016%22%5D")
      .to_return(status: 200, body: "", headers: {})

    Dhis2.client.analytics.list(
      periods:            %w[2016Q1 2016],
      organisation_units: %w[123 456],
      data_elements:      ["de-987"]
    )
  end

  context "with stubbed data" do
    let(:data_element_id) { "h0xKKjijTdI" }
    let(:organisation_unit_id) { "vWbkYPRmKyS" }
    let(:period) { "2016" }

    it "returns expected data" do
      stub_request(:get, "https://play.dhis2.org/demo/api/analytics?dimension=pe:2016")
        .to_return(status: 200, body: fixture_content("dhis2", "analytics.json"))

      row = Dhis2.client.analytics.list(
        data_elements:      data_element_id,
        organisation_units: organisation_unit_id,
        periods: period
      )["rows"].first

      expect(data_element_id).to      eq row[0]
      expect(organisation_unit_id).to eq row[1]
      expect(period).to               eq row[2]
    end
  end
end
