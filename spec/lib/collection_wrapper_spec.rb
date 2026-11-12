# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::CollectionWrapper do
  let(:klass) do
    Class.new do
      def self.list(client, periods:, filter: nil)
        [client, periods, filter]
      end

      def self.find(client, id, options = {})
        [client, id, options]
      end
    end
  end
  let(:client) { double("client") }
  let(:wrapper) { described_class.new(klass, client) }

  it "forwards keyword arguments as keywords" do
    expect(wrapper.list(periods: "2016", filter: "x")).to eq([client, "2016", "x"])
  end

  it "forwards a positional hash as a positional hash" do
    expect(wrapper.find("id1", fields: ":all")).to eq([client, "id1", { fields: ":all" }])
  end

  it "responds to the wrapped class methods" do
    expect(wrapper).to respond_to(:list)
    expect(wrapper).not_to respond_to(:unknown)
  end
end
