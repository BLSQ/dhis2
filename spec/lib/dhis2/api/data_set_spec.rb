# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::DataSet do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#create" do
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

    it "should be create allow override of defaults" do
      stub_request(:get, "https://play.dhis2.org/demo/api/categoryCombos?fields=:all&filter=name:eq:default")
        .to_return(status: 200, body: fixture_content(:dhis2, "category_combos_default.json"))

      stub_request(:post, "https://play.dhis2.org/demo/api/metadata")
        .with(body: "{\"dataSets\":[{\"name\":\"datasetname\",\"shortName\":\"shortname\",\"code\":\"dataset_code\",\"periodType\":\"Quarterly\",\"dataElements\":[{\"id\":\"de_id_1\"}],\"organisationUnits\":[{\"id\":\"ou_id_1\"}],\"categoryCombo\":{\"id\":\"p0KPaWEg3cf\",\"name\":\"default\"},\"openFuturePeriods\":3}]}")
        .to_return(status: 200, body: "", headers: {})

      status = data_sets.create(
        [
          {
            name:                  "datasetname",
            short_name:            "shortname",
            code:                  "dataset_code",
            period_type:           "Quarterly",
            open_future_periods:   3,
            data_element_ids:      ["de_id_1"],
            organisation_unit_ids: ["ou_id_1"]
          }
        ]
      )

      expect(status).to be_a(Dhis2::Status)
    end
  end
end
