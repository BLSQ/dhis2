# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Case do
  describe ".deep_change" do
    let(:camelized) do
      [
        {
          "fooBar" => ["bar_baz barBaz"]
        }
      ]
    end
    let(:underscored) do
      [
        {
          "foo_bar" => ["bar_baz barBaz"]
        }
      ]
    end
    it "converts underscore to camelcase" do
      expect(described_class.deep_change(underscored, :camelize)).to eq camelized
    end

    it "converts camelcase to underscore" do
      expect(described_class.deep_change(camelized, :underscore)).to eq underscored
    end
  end

  describe ".camelize" do
    it "changes case of nested structures" do
      expect(described_class.camelize("foo_bar", true)).to  eq "FooBar"
      expect(described_class.camelize("foo_bar", false)).to eq "fooBar"
    end
  end

  describe ".underscore" do
    it "changes case of nested structures" do
      expect(described_class.underscore("fooBar")).to eq "foo_bar"
    end
  end
end
