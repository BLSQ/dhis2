# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::Version227::LegendSet do
  it_behaves_like "a DHIS2 listable resource",  version: "2.27"
  it_behaves_like "a DHIS2 findable resource",  version: "2.27"
end
