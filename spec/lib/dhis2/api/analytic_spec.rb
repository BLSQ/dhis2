# frozen_string_literal: true

RSpec.describe Dhis2::Api::Analytic do
  it "should list by dimension ou, dx, pe and extra filter" do
    stub_request(:get, "https://play.dhis2.org/demo/api/analytics?dimension=pe:%5B%222016Q1%22,%20%222016%22%5D")
      .to_return(status: 200, body: "", headers: {})

    Dhis2.client.analytics.list(
      periods:            %w[2016Q1 2016],
      organisation_units: %w[123 456],
      data_elements:      ["de-987"]
    )
  end
end
