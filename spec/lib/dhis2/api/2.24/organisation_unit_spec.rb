# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version224::OrganisationUnit do
  it_behaves_like "a DHIS2 listable resource",  version: "2.24"
  it_behaves_like "a DHIS2 findable resource",  version: "2.24"
  it_behaves_like "a DHIS2 creatable resource", version: "2.24"
  it_behaves_like "a DHIS2 updatable resource", version: "2.24"
  it_behaves_like "a DHIS2 deletable resource", version: "2.24"

  describe "#parent_id" do
    it "returns parent id" do
      org_unit = described_class.new(
        double("client"),
        "parent" => { "id" => "1" }
      )
      expect(org_unit.parent_id).to eq "1"
    end
  end

  describe "#children_ids" do
    it "returns children_ids" do
      org_unit = described_class.new(
        double("client"),
        "children" => [
          { "id" => "1" },
          { "id" => "2" }
        ]
      )
      expect(org_unit.children_ids).to eq %w(1 2)
    end
  end
end
