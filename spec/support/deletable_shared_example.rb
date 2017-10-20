RSpec.shared_examples "a DHIS2 deletable resource" do |version:|
  let(:client) { build_client(version) }
  let(:object) { described_class.new(client, id: "fake_id") }
  let(:resource_key) { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe "#delete" do
    context "success" do
      before do
        stub_request(:delete, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
          .to_return(status: 204)
      end

      it "triggers the expected request" do
        expect(object.delete).to be true
      end
    end
    context "error" do
      it "raises on 500" do
        stub_request(:delete, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
          .to_return(status: 500, body: "{\"httpStatus\":\"Internal Server Error\",\"httpStatusCode\":500,\"status\":\"ERROR\",\"message\":\"could not execute statement\"}")
        expect { object.delete }.to raise_error(RestClient::Exception)
      end

      it "raises on 409" do
        stub_request(:delete, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
          .to_return(status: 409, body: "{\"httpStatus\":\"Conflict\",\"httpStatusCode\":409,\"status\":\"ERROR\",\"message\":\"Could not delete due to association with another object\"}")
        expect { object.delete }.to raise_error(RestClient::Exception)
      end
    end
  end
end