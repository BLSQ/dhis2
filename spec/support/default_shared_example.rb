# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 resource with default" do |version:, query: {}|
    let(:client) { build_client(version) }
    let(:resource_key)  { described_class.resource_key }
    let(:resource_name) { described_class.resource_name }
    let(:raw_json_response) { fixture_content(version, "list", "#{resource_key}.json") }
    let(:json_response) { JSON.parse(raw_json_response) }
    let(:camelized_resource_key) { camelize(resource_key) }
  
    def camelize(s)
      ::Dhis2::Case.camelize(s.to_s, false)
    end
  
    describe ".default" do
      def action
        described_class.default(client)
      end
  
      context "successful request" do
  
        before do
          stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}?fields=:all&filter=name:eq:default")
            .to_return(status: 200, body: raw_json_response)
        end
  
        it "returns the default value of the resource" do
          response = action
          expect(response.id).not_to be_nil
        end
      end
    end
  end
  