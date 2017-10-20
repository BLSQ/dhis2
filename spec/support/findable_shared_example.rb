# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 findable resource" do |version:|
  let(:client) { build_client(version) }
  let(:resource_key)  { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe ".find" do
    context "find one id" do
      def action(_options = {})
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
end