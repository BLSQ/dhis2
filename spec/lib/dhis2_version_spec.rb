
# frozen_string_literal: true

require "spec_helper"

RSpec.describe Dhis2::VERSION do
  it "should be set" do
    expect(Dhis2::VERSION).not_to be_empty
  end

  it_behaves_like "it matches version", "2.24"
  it_behaves_like "it matches version", "2.25"
  it_behaves_like "it matches version", "2.26"
  it_behaves_like "it matches version", "2.27"
  it_behaves_like "it matches version", "2.28"
end
