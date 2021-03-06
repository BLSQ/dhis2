# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version226::CategoryOptionCombo do
  it_behaves_like "a DHIS2 listable resource",     version: "2.26"
  it_behaves_like "a DHIS2 findable resource",     version: "2.26"
  it_behaves_like "a DHIS2 creatable resource",    version: "2.26"
  it_behaves_like "a DHIS2 updatable resource",    version: "2.26"
  it_behaves_like "a DHIS2 deletable resource",    version: "2.26"
  it_behaves_like "a DHIS2 resource with default", version: "2.26"
end
