
require "spec_helper"

RSpec.describe Dhis2::VERSION do
  it "should be set" do
    expect(Dhis2::VERSION).not_to be_empty
  end
end
