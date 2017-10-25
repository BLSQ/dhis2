# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 listable resource" do |version:, query: {}|
  let(:client) { build_client(version) }
  let(:resource_key)  { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }

  describe ".list" do
    def action(query)
      described_class.list(client, query)
    end

    def query_string(query)
      if query.any?
        "?" + query.map { |k, v| "#{Dhis2::Case.camelize(k.to_s, false)}=#{v}" }.join("&")
      else
        ""
      end
    end

    context "successful request" do
      let(:json_response) { fixture_content(version, "list", "#{resource_key}.json") }

      before do
        stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}#{query_string(query)}")
          .to_return(status: 200, body: json_response)
      end

      it "returns a PaginatedArray" do
        response = action(query)
        expect(response).to be_a Dhis2::PaginatedArray
        expect(response[0]).to be_a described_class
      end

      it "returns expected content" do
        response = action(query)
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
