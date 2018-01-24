# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 findable resource" do |version:|
  let(:client) { build_client(version) }
  let(:resource_key)  { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe ".find" do
    context "find one id" do
      def action
        described_class.find(client, fake_id)
      end

      let(:fake_id) { "fake_id" }
      let(:json_response) { fixture_content(version, "find", "#{resource_key}.json") }

      before do
        stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}/#{fake_id}")
          .to_return(status: 200, body: json_response)
      end

      it "returns a resource" do
        response = action
        expect(response).to be_a described_class
        Dhis2::Case.deep_change(JSON.parse(json_response), :underscore).tap do |elt|
          elt.each do |k, v|
            method_name = Dhis2::Case.underscore(k)
            expect(response.public_send(method_name)).to eq v
          end
        end
      end
    end
  end

  describe ".find_paginated" do

    def action
      described_class.find_paginated(client, ids, batch_size: 2)
    end

    let(:ids) { [1, 2, 3, 4] }

    it "finds per batch" do
      expect(described_class).to receive(:find).with(client, [1, 2], fields: :all, raw: false).and_return ["a", "b"]
      expect(described_class).to receive(:find).with(client, [3, 4], fields: :all, raw: false).and_return ["c", "d"]

      expect(action.to_a).to eq ["a", "b", "c", "d"]
    end
  end
end
