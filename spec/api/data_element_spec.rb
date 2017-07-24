# frozen_string_literal: true

RSpec.describe Dhis2::Api::DataElement do
  it "should list data elements" do
    stub_request(:get, "https://play.dhis2.org/demo/api/dataElements?fields=id,shortName,displayName,code&pageSize=1")
      .to_return(status: 200, body: fixture_content(:dhis2, "data_elements.json"))

    data_elements = Dhis2.client.data_elements.list(fields: %w[id shortName displayName code], page_size: 1)
    expect(data_elements.size).to eq 1

    data_element = data_elements.first

    expect(data_element.display_name).to eq "Accute Flaccid Paralysis (Deaths < 5 yrs)"
    expect(data_element.id).to eq "FTRrcoaog83"
    expect(data_element.short_name).to eq "Accute Flaccid Paral (Deaths < 5 yrs)"
  end

  describe "#create" do
    let(:data_element_1) do
      {
        "name"                => "TesTesT1148",
        "shortName"           => "TTT1148",
        "code"                => "TTT1148",
        "domainType"          => "AGGREGATE",
        "valueType"           => "NUMBER",
        "aggregationType"     => "SUM",
        "type"                => "int",
        "aggregationOperator" => "SUM",
        "zeroIsSignificant"   => true,
        "categoryCombo"       => {
          "id" => "p0KPaWEg3cf", "name" => "default"
        }
      }
    end

    let(:data_element_2) do
      {
        "name" => "TesTesT7712",
         "shortName" => "TTT7712",
         "code" => "TTT7712", "domainType" => "AGGREGATE",
         "valueType" => "NUMBER",
         "aggregationType" => "SUM",
         "type" => "int",
         "aggregationOperator" => "SUM",
         "zeroIsSignificant"   => true,
         "categoryCombo" => {
           "id" => "p0KPaWEg3cf", "name" => "default"
         }
      }
    end

    it "should create data element with default category combo if not present and preheatCache=false to speed on large dhis2 instances" do
      combo_stub = stub_request(:get, "https://play.dhis2.org/demo/api/categoryCombos?fields=:all&filter=name:eq:default")
                   .to_return(status: 200, body: fixture_content(:dhis2, "category_combos_default.json"))

      stub_data_elements_create_on_meta

      elements = [
        { name: data_element_1["name"], short_name: data_element_1["shortName"] },
        { name: data_element_2["name"], short_name: data_element_2["shortName"] }
      ]

      status = Dhis2.client.data_elements.create(elements)

      expect(status.success?).to eq true
      expect(status.total_imported).to eq 2
      expect(combo_stub).to have_been_made.once
    end

    def stub_data_elements_create_on_meta
      stub_request(:post, "https://play.dhis2.org/demo/api/metadata?preheatCache=false")
        .with(
          body: JSON.generate(
            "dataElements" => [
              data_element_1,
              data_element_2
            ]
          )
        )
        .to_return(status: 200, body: fixture_content(:dhis2, "data_element_create_status.json"))
    end
  end
end
