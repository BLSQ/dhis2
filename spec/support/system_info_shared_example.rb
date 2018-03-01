# frozen_string_literal: true
RSpec.shared_examples "a system info" do |version:|
  let(:client) { build_client(version) }

  it "lists by dimension ou, dx, pe and extra filter" do
    stub_request(:get, "https://play.dhis2.org/demo/api/system/info")
      .to_return(status: 200, body: generic_fixture_content(version, "system_info.json"), headers: {})

    resp = client.system_infos.get

    expect(resp["version"]).to eq version
  end
end
