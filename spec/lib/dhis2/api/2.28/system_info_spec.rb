# frozen_string_literal: true

RSpec.describe Dhis2::Api::SystemInfo do
  it "fetches system_infos" do
    stub_system_infos

    system_info = Dhis2.client.system_infos.get

    expect(system_info["version"]).to eq "2.27"
    expect(system_info["context_path"]).to eq "https://play.dhis2.org/demo"
    expect(system_info["database_info"]).to eq("type" => "PostgreSQL", "spatial_support" => true)
    expect(system_info["date_format"]).to eq "yyyy-mm-dd"
  end

  def stub_system_infos
    stub_request(:get, "https://play.dhis2.org/demo/api/system/info")
      .to_return(status: 200, body: fixture_content(:dhis2, "system_info.json"))
   end
end
