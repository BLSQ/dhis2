
# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::DataSet do
  let(:data_sets) { Dhis2.client.data_sets }
  it "should be create with defaults" do
    stub_request(:get, "https://play.dhis2.org/demo/api/categoryCombos?fields=:all&filter=name:eq:default")
      .to_return(status: 200, body: fixture_content(:dhis2, "category_combos_default.json"))

    stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
      .with(body: "{\"dataSets\":[{\"name\":\"datasetname\",\"shortName\":\"shortname\",\"code\":\"dataset_code\",\"periodType\":\"Monthly\",\"dataElements\":[{\"id\":\"de_id_1\"}],\"organisationUnits\":[{\"id\":\"ou_id_1\"}],\"categoryCombo\":{\"id\":\"p0KPaWEg3cf\",\"name\":\"default\"}}]}")
      .to_return(status: 200, body: "", headers: {})

    status = data_sets.create(
      [
        {
          name:                  "datasetname",
          short_name:            "shortname",
          code:                  "dataset_code",
          data_element_ids:      ["de_id_1"],
          organisation_unit_ids: ["ou_id_1"]
        }
      ]
    )

    expect(status).to be_a(Dhis2::Status)
  end
end
