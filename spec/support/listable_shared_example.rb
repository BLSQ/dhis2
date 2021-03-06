# frozen_string_literal: true
RSpec.shared_examples "a DHIS2 listable resource" do |version:, query: {}|
  let(:client) { build_client(version) }
  let(:resource_key)  { described_class.resource_key }
  let(:resource_name) { described_class.resource_name }
  let(:raw_json_response) { fixture_content(version, "list", "#{resource_key}.json") }
  let(:json_response) { JSON.parse(raw_json_response) }
  let(:camelized_resource_key) { camelize(resource_key) }

  def camelize(s)
    ::Dhis2::Case.camelize(s.to_s, false)
  end

  def query_string(query)
    if query.any?
      "?" + query.map { |k, v| "#{camelize(k)}=#{v}" }.join("&")
    else
      ""
    end
  end

  describe ".list" do
    def action(query, raw)
      described_class.list(client, query, raw)
    end

    context "successful request" do

      before do
        stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}#{query_string(query)}")
          .to_return(status: 200, body: raw_json_response)
      end

      it "returns a PaginatedArray" do
        response = action(query, false)
        expect(response).to be_a Dhis2::PaginatedArray
        expect(response[0]).to be_a described_class
      end

      it "returns expected content raw" do
        response = action(query, true)
        if json_response.key?("pager")
          expect(response.pager.page).to       eq json_response["pager"]["page"]
          expect(response.pager.page_count).to eq json_response["pager"]["pageCount"]
          expect(response.pager.total).to      eq json_response["pager"]["total"]
          expect(response.pager.next_page).to  eq json_response["pager"]["nextPage"]
        end
        json_response.fetch(resource_key, []).each_with_index do |elt, index|
          elt.each do |k, v|
            expect(response[index][k]).to eq v
          end
        end
      end

      it "returns expected content not raw" do
        response = action(query, false)
        Dhis2::Case.deep_change(json_response, :underscore).tap do |hash|
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

  describe ".fetch_paginated_data" do
    def action(query, options = {})
      stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}#{query_string(query.merge(page: 1))}")
        .to_return(status: 200, body: page1.to_json)
      stub_request(:get, "https://play.dhis2.org/demo/api/#{resource_name}#{query_string(query.merge(page: 2))}")
        .to_return(status: 200, body: page2.to_json)

      described_class.fetch_paginated_data(client, query, options)
    end

    # we provide bogus pagination stuff here to force http requests
    let(:page1) { json_response.clone.tap {|json|
      json["pager"] =  {
        "page": 1,
        "pageCount": 2,
        "total": 10,
        "pageSize": 6
      }
    }}
    let(:page2) { json_response.clone.tap {|json|
      json["pager"] =  {
        "page": 2,
        "pageCount": 2,
        "total": 10,
        "pageSize": 6
      }
    }}

    it "with pager" do
      if described_class.paginated
        max = 0
        action(query.clone, { with_pager: true }).each do |elt, pager|
          max += 1
          expect(elt).to be_a described_class
          expect(pager).to be_a ::Dhis2::Pager
        end
        expect(max).to eq(json_response[camelized_resource_key].count * 2)
      end
    end

    it "without pager" do
      if described_class.paginated
        max = 0
        action(query.clone).each do |elt|
          max += 1
          expect(elt).to be_a described_class
        end
        expect(max).to eq(json_response[camelized_resource_key].count * 2)
      end
    end
  end
end
