# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version226::DataValueSet do
  let(:client) { build_client("2.26") }
  it_behaves_like "a DHIS2 data value list", version: "2.26"
end
