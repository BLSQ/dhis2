# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 updatable resource" do |version:|
  let(:client) { build_client(version) }
  let(:object) { described_class.new(client, id: "fake_id") }
  let(:resource_key) { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe "#update" do
    let(:json_response) { generic_fixture_content(version, "update.json") }

    before do
      stub_request(:put, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
        .with(body: { id: "fake_id" }.to_json)
        .to_return(status: 200, body: json_response)
    end

    it "triggers the expected request" do
      object.update
    end
  end

  describe "#update_attributes" do
    let(:updates_hash) { { name: "updated name" } }
    before do
      stub_request(:patch, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
        .with(body: updates_hash.to_json)
        .to_return(status: 200)
    end

    it "triggers the expected request and sets props" do
      object.update_attributes(updates_hash)
      updates_hash.each do |k, v|
        expect(object.public_send(k)).to eq v
      end
    end
  end
end
