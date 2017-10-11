# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::OrganisationUnitGroupSet do
  it_behaves_like "a DHIS2 listable resource"
  it_behaves_like "a DHIS2 findable resource"
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"
end
