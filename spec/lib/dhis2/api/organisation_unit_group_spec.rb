# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::OrganisationUnitGroup do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#create" do
    it "shoud expose map ou groups" do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"organisationUnitGroups\":[{\"name\":\"oug_name\",\"shortName\":\"oug_short_name\",\"code\":\"code\"}]}")
        .to_return(status: 200, body: "", headers: {})

      status = Dhis2.client.organisation_unit_groups.create(
        [
          {
            name:       "oug_name",
            short_name: "oug_short_name",
            code:       "code"
          }
        ]
      )

      expect(status).to be_a(Dhis2::Status)
    end
  end
end
