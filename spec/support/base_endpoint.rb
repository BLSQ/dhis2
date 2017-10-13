# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 listable resource" do
  let(:client) { Dhis2.client }
  let(:resource_key)  { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe ".list" do
    def action(options = {})
      described_class.list(client, options)
    end

    context "successful request" do
      let(:json_response) { fixture_content("list", "#{resource_key}.json") }

      before do
        stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}")
          .to_return(status: 200, body: json_response)
      end

      it "returns a PaginatedArray" do
        response = action
        expect(response).to be_a Dhis2::PaginatedArray
        expect(response[0]).to be_a described_class
      end

      it "returns expected content" do
        response = action
        Dhis2::Case.deep_change(JSON.parse(json_response), :underscore).tap do |hash|
          if hash.key?("pager")
            expect(response.pager.page).to       eq hash["pager"]["page"]
            expect(response.pager.page_count).to eq hash["pager"]["page_count"]
            expect(response.pager.total).to      eq hash["pager"]["total"]
            expect(response.pager.next_page).to  eq hash["pager"]["next_page"]
          end
          hash.fetch(resource_key, []).each_with_index do |elt, index|
            elt.each do |k, v|
              method_name = Dhis2::Case.underscore(k)
              expect(response[index].public_send(method_name)).to eq v
            end
          end
        end
      end
    end
  end
end

RSpec.shared_examples "a DHIS2 findable resource" do
  let(:client) { Dhis2.client }
  let(:resource_key) { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe ".find" do
    context "find one id" do
      def action(_options = {})
        described_class.find(client, fake_id)
      end

      let(:fake_id) { "fake_id" }
      let(:json_response) { fixture_content("find", "#{resource_key}.json") }

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

RSpec.shared_examples "a DHIS2 updatable resource" do |req_body: {}|
  let(:client) { Dhis2.client }
  let(:object) { described_class.new(client, id: "fake_id") }
  let(:resource_key) { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe "#update" do
    let(:json_response) { fixture_content("update", "#{resource_key}.json") }

    before do
      stub_request(:put, "https://play.dhis2.org/demo/api/#{resource_name}/#{object.id}")
        .with(body: { id: "fake_id", displayName: nil }.merge(req_body).to_json)
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

RSpec.shared_examples "a DHIS2 deletable resource" do
  let(:client) { Dhis2.client }
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
