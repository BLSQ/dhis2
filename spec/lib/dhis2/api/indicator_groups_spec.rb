# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::DataValueSet do
  describe "#find" do
    it "should find indicator groups" do
      stub_request(:get, "https://play.dhis2.org/demo/api/indicatorGroups")
        .to_return(status: 200, body: fixture_content(:dhis2, "indicator_groups.json"))

      indicator_groups = Dhis2.client.indicator_groups.list
      expect(indicator_groups.size).to eq 17
      expect(indicator_groups.first.display_name).to eq "ANC"
    end
  end
end
