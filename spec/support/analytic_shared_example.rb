# frozen_string_literal: true

RSpec.shared_examples "an analytic endpoint" do |version:|
  # actually webmock doesnt work with same param multiple times
  # see https://github.com/bblimke/webmock/issues/330

  let(:client) { build_client(version) }

  it "lists by dimension ou, dx, pe and extra filter" do
    stub_request(:get, "https://play.dhis2.org/demo/api/analytics?dimension=ou%3A%5B%22123%22%2C+%22456%22%5D&dimension=pe%3A%5B%222016Q1%22%2C+%222016%22%5D&dimension=dx%3A%5B%22de-987%22%5D")
      .to_return(status: 200, body: "", headers: {})

    client.analytics.list(
      periods:            %w[2016Q1 2016],
      organisation_units: %w[123 456],
      data_elements:      ["de-987"]
    )
  end

  context "with stubbed data" do
    let(:data_element_id) { "h0xKKjijTdI" }
    let(:organisation_unit_id) { "vWbkYPRmKyS" }
    let(:period) { "2016" }

    before do
      stub_api_request
    end

    it "returns expected data" do
      row = client.analytics.list(
        data_elements:      data_element_id,
        organisation_units: organisation_unit_id,
        periods:            period
      )["rows"].first

      expect(data_element_id).to      eq row[0]
      expect(organisation_unit_id).to eq row[1]
      expect(period).to               eq row[2]
    end

    context "with raw data option" do
      it "returns expected data " do
        row = client.analytics.list(
          data_elements:      data_element_id,
          organisation_units: organisation_unit_id,
          periods:            period,
          raw:                true
        )
        expect(row["metaData"]["items"][data_element_id]["name"]).to eq("Expected pregnancies")
        expect(row["rows"].first).to eq([data_element_id, organisation_unit_id, period, "3583.0"])
      end
    end

    def stub_api_request
      stub_request(:get, "https://play.dhis2.org/demo/api/analytics?dimension=ou%3AvWbkYPRmKyS&dimension=pe%3A2016&dimension=dx%3Ah0xKKjijTdI")
        .to_return(status: 200, body: shared_content("analytics.json"))
    end
  end
end
