# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version225::DataValueSet do
  let(:client) { build_client("2.25") }

  it_behaves_like "a DHIS2 creatable resource", version: "2.25", nil_id: true
  it_behaves_like "a DHIS2 data value list", version: "2.25"
end
