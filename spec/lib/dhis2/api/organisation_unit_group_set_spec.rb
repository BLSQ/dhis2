# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::OrganisationUnitGroupSet do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#create" do
    it "shoud expose map ou groups" do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"organisationUnitGroupSets\":[{\"name\":\"Facility Type\"," \
        "\"organisationUnitGroups\":[{\"id\":\"uYxK4wmcPqA\"},{\"id\":\"EYbopBOJWsW\"}]}]}")
        .to_return(
          status: 200,
          body:   fixture_content(:create, "organisation_unit_groups_sets_status_created.json")
        )

      status = Dhis2.play.organisation_unit_group_sets.create(
        [
          {
            name:                   "Facility Type",
            organisationUnitGroups: [
              {
                id: "uYxK4wmcPqA"
              },
              {
                id: "EYbopBOJWsW"
              }
            ]

          }
        ]
      )

      expect(status).to be_a(Dhis2::Status)
    end
  end
end
