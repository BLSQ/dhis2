# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::OrganisationUnit do
  describe "#initialize" do
    it "should ensure backward compatibility for parent id" do
      org_unit = Dhis2::Api::OrganisationUnit.new(
        Dhis2.client,
        "parent" => { "id" => "1" }
      )
      expect(org_unit.parent_id).to eq "1"
    end

    it "should ensure backward compatibility for children_ids" do
      org_unit = Dhis2::Api::OrganisationUnit.new(
        Dhis2.client,
        "children" => [
          { "id" => "1" },
          { "id" => "2" }
        ]
      )
      expect(org_unit.children_ids).to eq %w[1 2]
    end
  end

  describe "#create" do
    it "should post to metadata imports" do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"organisationUnits\":[{\"parentId\":1,\"parent\":{\"id\":1}}]}")
        .to_return(status: 200, body: "")

      import_status = Dhis2.client.organisation_units.create(parent_id: 1)

      expect(import_status).to be_a(Dhis2::Status)
    end

    it "should post to metadata imports and ensure backward compatibility for organisationUnits " do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"organisationUnits\":[{\"parentId\":1,\"organisationUnits\":[{\"id\":4}],\"parent\":{\"id\":1}}]}")
        .to_return(status: 200, body: "", headers: {})

      import_status = Dhis2.client.organisation_units.create(parent_id: 1, organisationUnits: [{ id: 4 }])

      expect(import_status).to be_a(Dhis2::Status)
    end
  end

  describe "#last_level_descendants" do
    it "should support last_level_descendants by id" do
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnitLevels?fields=:all")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_unit_levels.json"))
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits/123?includeDescendants=true")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units_with_descendants.json"))
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units.json"))
      Dhis2.client.organisation_units.last_level_descendants(123)
    end
  end

  describe "#find" do
    it "should find by id" do
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits/123")
        .to_return(status: 200, body: "", headers: {})

      Dhis2.client.organisation_units.find(123)
    end

    it "should find for array of ids" do
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits?fields=:all&filter=id:in:%5B123,456%5D&pageSize=2")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units.json"))

      Dhis2.client.organisation_units.find(%w[123 456], ignore: :option)
    end

    it "should support include descendants option" do
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits/123?includeDescendants=true")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units_with_descendants.json"))

      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units.json"))

      orgs = Dhis2.client.organisation_units.find(123, include_descendants: true)
      expect(orgs).to be_an(Dhis2::PaginatedArray)
      expect(orgs.size).to eq 50
    end
  end
end
