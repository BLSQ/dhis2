# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version225::ReportTable do
  it_behaves_like "a DHIS2 listable resource",  version: "2.25"
  it_behaves_like "a DHIS2 findable resource",  version: "2.25"
  it_behaves_like "a DHIS2 creatable resource", version: "2.25", nil_id: true
  it_behaves_like "a DHIS2 updatable resource", version: "2.25"
  it_behaves_like "a DHIS2 deletable resource", version: "2.25"
end
