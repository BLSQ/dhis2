# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Indicator do
  it_behaves_like "a DHIS2 listable resource", 'indicators'
  it_behaves_like "a DHIS2 findable resource", 'indicators'
  it_behaves_like "a DHIS2 updatable resource"
  it_behaves_like "a DHIS2 deletable resource"
end
