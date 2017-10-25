# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 creatable resource" do |version:, nil_id: false|
  let(:client) { build_client(version) }
  let(:object) { described_class.new(client, id: "fake_id") }
  let(:resource_key) { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe "#create" do
    let(:fixture)  { JSON.parse(fixture_content(version, "create", "#{resource_key}.json")) }
    let(:request)  { fixture["request"]  }
    let(:response) { fixture["response"] }
    let(:args) { Dhis2::Case.deep_change(request, :underscore) }

    def action(args)
      described_class.create(client, symbolize_keys(args))
    end

    context "success" do
      before do
        stub_request(:post, "https://play.dhis2.org/demo/api/#{resource_name}")
          .with(body: request.to_json)
          .to_return(status: 200, body: response.to_json)
      end

      it "triggers the expected request" do
        instance = action(args)
        expect(instance).to be_a described_class
        expect(instance.id).to_not be nil unless nil_id
      end
    end

    context "error" do
      it "raises on invalid params" do
        expect { action({}) }.to raise_error(Dhis2::CreationError)
      end

      it "raises on 409" do
        stub_request(:post, "https://play.dhis2.org/demo/api/#{resource_name}")
          .to_return(status: 409, body: "{\"httpStatus\":\"Conflict\",\"httpStatusCode\":409,\"status\":\"ERROR\",\"message\":\"One more more errors occurred, please see full details in import report.")
        expect { action(args) }.to raise_error(RestClient::Exception)
      end
    end
  end
end
