# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::ResourceTable do
    it "should start updating analytics" do
      stub_resource_tables

      response = Dhis2.client.resource_tables.analytics
      
      expect(response.success?).to eq true
      expect(response.raw_status["message"]).to eq "Initiated resource table update"
    end

  def stub_resource_tables
    stub_request(:post, "https://play.dhis2.org/demo/api/resourceTables")
      .to_return(status: 200, body: fixture_content(:dhis2, "resource_tables.json"))
  end


end
