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

  describe "#find" do
    it "should find for array of ids" do
      stub_request(:get, "https://play.dhis2.org/demo/api/organisationUnits?fields=:all&filter=id:in:%5B123,456%5D&pageSize=2")
        .to_return(status: 200, body: fixture_content(:dhis2, "organisation_units.json"))

      Dhis2.client.organisation_units.find(%w[123 456], ignore: :option)
    end
  end
end
