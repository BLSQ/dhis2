# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::DataElement do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"

  describe "#create" do
    let(:data_element_1) do
      {
        name:                 "TesTesT1148",
        short_name:           "TTT1148",
        code:                 "TTT1148",
        domain_type:          "AGGREGATE",
        value_type:           "NUMBER",
        aggregation_type:     "SUM",
        type:                 "int",
        aggregation_operator: "SUM",
        zero_is_significant:  true,
        category_combo:       {
          id: "p0KPaWEg3cf", name: "default"
        }
      }
    end

    let(:data_element_2) do
      {
        name:                 "TesTesT7712",
        short_name:           "TTT7712",
        aggregation_operator: "SUM",
        category_combo:       {
          id: "p0KPaWEg3cf", name: "default"
        }
      }
    end

    let(:data_element_2_with_defaults) do
      {
        name:                 "TesTesT7712",
        short_name:           "TTT7712",
        code:                 "TTT7712",
        domain_type:          "AGGREGATE",
        value_type:           "NUMBER",
        aggregation_type:     "SUM",
        type:                 "int",
        aggregation_operator: "SUM",
        zero_is_significant:  true,
        category_combo:       {
          id: "p0KPaWEg3cf", name: "default"
        }
      }
    end

    it "should create data element with default category combo if not present and preheatCache=false to speed on large dhis2 instances" do
      combo_stub = stub_request(:get, "https://play.dhis2.org/demo/api/categoryCombos?fields=:all&filter=name:eq:default")
                   .to_return(status: 200, body: fixture_content(:dhis2, "category_combos_default.json"))

      stub_data_elements_create_on_meta

      status = Dhis2.client.data_elements.create([data_element_1, data_element_2])

      expect(status.success?).to eq true
      expect(status.total_imported).to eq 2
      expect(combo_stub).to have_been_made.once
    end

    def stub_data_elements_create_on_meta
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata?preheatCache=false")
        .with(body: JSON.generate("dataElements" => Dhis2::Case.deep_change([data_element_1, data_element_2_with_defaults], :camelize)))
        .to_return(status: 200, body: fixture_content(:dhis2, "data_element_create_status.json"))
    end
  end
end
