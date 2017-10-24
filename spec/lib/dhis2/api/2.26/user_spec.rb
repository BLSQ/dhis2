# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version226::User do
  it_behaves_like "a DHIS2 listable resource",  version: "2.26"
  it_behaves_like "a DHIS2 findable resource",  version: "2.26"
  it_behaves_like "a DHIS2 updatable resource", version: "2.26"
  it_behaves_like "a DHIS2 deletable resource", version: "2.26"
end
