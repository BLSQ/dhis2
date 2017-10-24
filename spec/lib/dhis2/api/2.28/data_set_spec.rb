# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version228::DataSet do
  it_behaves_like "a DHIS2 listable resource",  version: "2.28"
  it_behaves_like "a DHIS2 findable resource",  version: "2.28"
  it_behaves_like "a DHIS2 creatable resource", version: "2.28"
  it_behaves_like "a DHIS2 updatable resource", version: "2.28"
  it_behaves_like "a DHIS2 deletable resource", version: "2.28"

  describe "#add_data_elements" do
    let(:client) { build_client("2.28") }
    let(:data_set) do
      described_class.new(client, { id: "ds_id", data_set_elements: [ { "data_element" => { "id" => "123" } } ] })
    end
    let(:stubbed_body) { %Q{{"id":"ds_id","dataSetElements":[{"dataElement":{"id":"123"}},{"dataElement":{"id":"345"}}]}} }

    context "success" do
      context "already existing" do
        it "doesnt do anything" do
          # nothing to check actually
          data_set.add_data_elements(["123"])
        end
      end

      context "non existing" do
        it "adds it" do
          stub_request(:put, "https://play.dhis2.org/demo/api/dataSets/ds_id")
            .with(body: stubbed_body)
            .to_return(status: 200, body: generic_fixture_content("2.28", "update.json"))

          data_set.add_data_elements(["345"])
          expect(data_set.data_element_ids).to include "345"
        end
      end
    end

    context "failure" do
      it "raises an exception when addition fails" do
        stub_request(:put, "https://play.dhis2.org/demo/api/dataSets/ds_id")
          .with(body: stubbed_body)
          .to_return(status: 500, body: "")

        expect { data_set.add_data_elements (["345"]) }.to raise_error(RestClient::Exception)
      end
    end
  end
end
