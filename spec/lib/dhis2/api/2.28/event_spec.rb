# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version228::Event do
  it_behaves_like "a DHIS2 listable resource",  version: "2.28", query: { org_unit: "foo" }
  it_behaves_like "a DHIS2 findable resource",  version: "2.28"
  it_behaves_like "a DHIS2 creatable resource", version: "2.28"
  it_behaves_like "a DHIS2 deletable resource", version: "2.28"
end
