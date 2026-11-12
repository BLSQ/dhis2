# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::Api::Base do
  let(:client) { double("client") }
  let(:raw) { { "id" => "de1", "name" => "Malaria cases", "categoryCombo" => { "id" => "cc1" } } }
  let(:resource) { Dhis2::Api::DataElement.new(client, raw) }

  it "exposes the raw attributes and the client" do
    expect(resource.id).to eq("de1")
    expect(resource.name).to eq("Malaria cases")
    expect(resource.category_combo).to be_nil
    expect(resource["categoryCombo"]).to eq("id" => "cc1")
    expect(resource.client).to eq(client)
  end

  it "defaults display_name to name (dhis2 2.19)" do
    expect(resource.display_name).to eq("Malaria cases")
  end

  it "supports setters, respond_to? and to_h" do
    resource.name = "renamed"
    expect(resource.name).to eq("renamed")
    expect(resource).to respond_to(:id)
    expect(resource).not_to respond_to(:unknown_attribute)
    expect(resource.to_h).to include(id: "de1", name: "renamed", client: client)
  end

  it "does not define a singleton method per attribute (slow on ruby >= 3.0)" do
    expect(resource.singleton_methods).to be_empty
  end
end
