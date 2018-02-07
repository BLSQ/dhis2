# frozen_string_literal: true
RSpec.shared_examples "it matches version" do |version|

  it "retrieves proper version" do
    stub_request(:get, "https://play.dhis2.org/demo/api/system/info")
      .to_return(status: 200, body: generic_fixture_content(version, "system_info.json"))

    retrieved_version = Dhis2.get_version({ user: 'admin', password: 'district', url: 'https://play.dhis2.org/demo'})

    expect(retrieved_version).to eq version
  end
end
