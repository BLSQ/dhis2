# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version224::DataSet do
  it_behaves_like "a DHIS2 listable resource",  version: "2.24"
  it_behaves_like "a DHIS2 findable resource",  version: "2.24"
  it_behaves_like "a DHIS2 creatable resource", version: "2.24"
  it_behaves_like "a DHIS2 updatable resource", version: "2.24"
  it_behaves_like "a DHIS2 deletable resource", version: "2.24"

  describe "#add_data_elements" do
    let(:client) { build_client("2.24") }
    let(:data_set) do
      described_class.new(client, id: "ds_id", data_elements: [{ "id" => "123" }])
    end

    context "success" do
      context "already existing" do
        it "doesnt do anything" do
          # nothing to check actually
          data_set.add_data_elements(["123"])
        end
      end

      context "non existing" do
        let(:updated_set) do
          described_class.new(client, id: "ds_id", data_elements: [{ "id" => "123" }, { "id" => "345" }])
        end

        it "creates it" do
          stub_request(:post, "https://play.dhis2.org/demo/api/dataSets/ds_id/dataElements/345")
            .with(body: "{}")
            .to_return(status: 204, body: "")

          expect(described_class).to receive(:find).with(client, "ds_id").and_return(updated_set)

          data_set.add_data_elements(["345"])
          expect(data_set.data_element_ids).to include "345"
        end
      end
    end

    context "failure" do
      it "raises an exception when addition fails" do
        stub_request(:post, "https://play.dhis2.org/demo/api/dataSets/ds_id/dataElements/345")
          .with(body: "{}")
          .to_return(status: 204, body: "")

        expect(described_class).to receive(:find).with(client, "ds_id").and_return(data_set)

        expect { data_set.add_data_elements(["345"]) }.to raise_error(Dhis2::DataElementAdditionError)
      end
    end
  end
end
