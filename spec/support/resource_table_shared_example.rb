# frozen_string_literal: true
RSpec.shared_examples "a resource table" do |version:|
  let(:client) { build_client(version) }

  it "makes proper request" do
    request = stub_request(:post, "https://play.dhis2.org/demo/api/resourceTables/analytics")
              .to_return(status: 200, body: generic_fixture_content("2.24", "resource_table_analytics.json"), headers: {})

    client.resource_tables.analytics

    expect(request).to have_been_made
  end
end
