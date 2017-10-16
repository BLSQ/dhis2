# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::CategoryCombo do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#create" do
    it "should create with a default data_dimension_type with disaggregation" do
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"categoryCombos\":[{\"name\":\"Posology\","\
                    "\"dataDimensionType\":\"DISAGGREGATION\"}]}")
        .to_return(
          status: 200,
          body:   fixture_content(:create, "category_combo_status_created.json")
        )

      status = Dhis2.play.category_combos.create(
        name: "Posology"
      )

      expect(status).to be_a(Dhis2::Status)
    end
  end
end
